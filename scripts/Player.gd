class_name Player
extends Area2D

export var speed: float = 20
export var min_plant_distance: float = 8

var flower_scene: PackedScene = preload("res://scenes/flower.tscn")
var active_item: PlayerItem = null
# TODO: Can items overlap? Should we solve that when dropping items?
var last_colliding_item: PlayerItem = null
var last_input: Vector2 = Vector2.ZERO
var controllable: bool = true

onready var planting_area := $PlantingArea as Area2D
onready var animated_sprite := $AnimatedSprite as AnimatedSprite
onready var item_mount_point := $ItemMountPoint as Node2D
onready var item_drop_point := $ItemDropPoint as Node2D

#sounds
onready var walking_sounds := $Sounds/WalkingSounds as OneShotPlayer
onready var motyka_sounds := $Sounds/MotykaSounds as OneShotPlayer
onready var pickup_sound := $Sounds/PickupSound as AudioStreamPlayer2D
onready var nejde_sound := $Sounds/ToNejdeSound as AudioStreamPlayer2D
onready var zasazeni_sound := $Sounds/ZasazeniSound as AudioStreamPlayer2D

func _ready():
	pass

func _process(delta: float):
	if not controllable:
		return

	apply_movement(delta)

	if Input.is_action_just_pressed("secondary"):
		print_debug(last_colliding_item)
		if last_colliding_item is PlayerItem:
			swap_items()
		else:
			drop_item()

	if active_item != null:
		active_item.position = item_mount_point.global_position

	if active_item != null and Input.is_action_just_pressed("primary"):
		use_active_item()

func _on_Player_area_entered(area):
	if area is PlayerItem:
		last_colliding_item = area
		var item = area as PlayerItem
		print_debug("Item type: %s" % item.type)

func _on_Player_area_exited(area):
	if area is PlayerItem and area == last_colliding_item:
		print_debug("item left")
		last_colliding_item = null

func use_active_item():
	match active_item.type:
		PlayerItem.Type.FlowerBox:
			use_flower_box()
		PlayerItem.Type.Hoe:
			use_hoe()

func use_hoe():
	var current_overlapping_weed: Weed = Util.get_first_overlapping_area_in_group(planting_area, "weed")
	if current_overlapping_weed == null:
		return
	current_overlapping_weed.hit()
	motyka_sounds.play()

func use_flower_box():
	if is_by_well():
		active_item.restore()
		return

	if not can_plant():
		print_debug("Cannot plant, nice")
		nejde_sound.play()
		return

	var flower = flower_scene.instance()
	flower.position = position

	var root = get_node("/root/main")
	root.add_child(flower)
	# TODO: Keep in front of the background
	var bg_index = root.get_node("Background").get_index()
	root.move_child(flower, bg_index)

	active_item.use()
	zasazeni_sound.play()
	
	
func swap_items():
	# TODO: Unparent currently active item
	drop_item()
	active_item = last_colliding_item
	last_colliding_item = null
	pickup_sound.play()
	
func drop_item():
	if active_item == null:
		return
	active_item.position = item_drop_point.global_position
	active_item = null

func apply_movement(delta: float):
	var last_facing = get_facing(last_input)
	var anim = "idle"

	var input = Vector2.ZERO
	if Input.is_action_pressed("left"):
		input.x = -speed
		
	if Input.is_action_pressed("right"):
		input.x = speed

	if input.length() > 0 and not walking_sounds.playing:
		walking_sounds.play()

	var facing = last_facing
	if input.length() > 0:
		facing = get_facing(input)
		anim = "walk"
		last_input = input

	# print_debug("last facing: %s, facing: %s" % [last_facing, facing])

	var current_anim = "%s_%s" % [anim, facing]
	# print_debug("current anim: %s" % current_anim)
	animated_sprite.animation = current_anim
		
	position += input * speed * delta

func get_facing(v: Vector2) -> String:
	if v.x < 0:
		return "left"
	else:
		return "right"

func can_plant():
	return not Util.is_currently_overlapping_node_in_group(planting_area, "flower") and not Util.is_currently_overlapping_node_in_group(planting_area, "weed")

func is_by_well():
	var overlaps_well = Util.is_currently_overlapping_node_in_group(self, "well")
	print_debug("Overlaps well: %s" % overlaps_well)
	return overlaps_well
