class_name Player
extends Area2D

export var speed: float = 20
export var min_plant_distance: float = 8
export var side_barier_limit = 130

var flower_scene: PackedScene = preload("res://scenes/flower.tscn")
var active_item: PlayerItem = null
var active_item_parent: Node = null
var active_item_index: int = -1
var last_colliding_item: PlayerItem = null
var last_input: Vector2 = Vector2.ZERO
var screen_size
var controllable: bool = true
var current_overlapping_weed: Weed = null

onready var planting_area := $PlantingArea as Area2D
onready var animated_sprite := $AnimatedSprite as AnimatedSprite
onready var item_mount_point := $ItemMountPoint as Node2D
onready var item_drop_point := $ItemDropPoint as Node2D
onready var animation_player := $AnimationPlayer as AnimationPlayer

#sounds
onready var walking_sounds := $Sounds/WalkingSounds as OneShotPlayer
onready var motyka_sounds := $Sounds/MotykaSounds as OneShotPlayer
onready var pickup_sound := $Sounds/PickupSound as AudioStreamPlayer2D
onready var nejde_sound := $Sounds/ToNejdeSound as AudioStreamPlayer2D
onready var zasazeni_sound := $Sounds/ZasazeniSound as AudioStreamPlayer2D

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta: float):
	if not controllable:
		return

	apply_movement(delta)

	if Input.is_action_just_pressed("secondary"):
		# print_debug(last_colliding_item)
		if last_colliding_item is PlayerItem:
			swap_items()
		else:
			drop_item()

	# if active_item != null:
	# 	print_debug(item_mount_point.global_position)
	# 	active_item.position = item_mount_point.global_position

	if active_item != null and Input.is_action_just_pressed("primary"):
		use_active_item()

func _on_Player_area_entered(area):
	if area is PlayerItem:
		last_colliding_item = area
		# var item = area as PlayerItem
		# print_debug("Item type: %s" % item.type)

func _on_Player_area_exited(area):
	if area is PlayerItem and area == last_colliding_item:
		# print_debug("item left")
		last_colliding_item = null

func _on_AnimatedSprite_animation_finished():
	controllable = true

func _on_AnimatedSprite_frame_changed():
	if "pickup" in animated_sprite.animation and animated_sprite.frame == 10:
		plant_flower()

func use_active_item():
	match active_item.type:
		PlayerItem.Type.FlowerBox:
			use_flower_box()
		PlayerItem.Type.Hoe:
			use_hoe()

func use_hoe():
	current_overlapping_weed = Util.get_first_overlapping_area_in_group(planting_area, "weed")
	if current_overlapping_weed == null or current_overlapping_weed.invincible:
		return

	# print_debug("playing use_hoe")
	animation_player.play("use_hoe")

func hoe_hit():
	current_overlapping_weed.hit()
	motyka_sounds.play()

func use_flower_box():
	if is_by_well():
		active_item.restore()
		return

	if not can_plant():
		# print_debug("Cannot plant, nice")
		nejde_sound.play()
		return

	active_item.use()

	animated_sprite.animation = "pickup_%s" % get_facing(last_input)
	controllable = false

func plant_flower():
	var flower = flower_scene.instance()
	flower.position = position

	var root = get_node("/root/main/Flowers")
	root.add_child(flower)

	zasazeni_sound.play()
	
func swap_items():
	# TODO: Item cannot be picked up/swapped in some cases
	drop_item()
	active_item = last_colliding_item
	active_item_parent = active_item.get_parent()
	active_item_index = active_item.get_index()
	active_item_parent.remove_child(active_item)
	item_mount_point.add_child(active_item)
	active_item.global_position = item_mount_point.global_position
	last_colliding_item = null
	pickup_sound.play()

	
func drop_item():
	if active_item == null:
		return
	item_mount_point.remove_child(active_item)
	active_item_parent.add_child(active_item)
	active_item_parent.move_child(active_item, active_item_index)
	active_item.position = item_drop_point.global_position
	active_item = null
	active_item_parent = null

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
		
	position.x = clamp(position.x, side_barier_limit, screen_size.x - side_barier_limit) 

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
	# print_debug("Overlaps well: %s" % overlaps_well)
	return overlaps_well


func _on_AnimationPlayer_animation_changed(old_name:String, new_name:String):
	print_debug("anim player chagned: %s -> %s" % [old_name, new_name])
