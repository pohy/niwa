extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed: float = 20
export var min_plant_distance: float = 8

var flower_scene: PackedScene = preload("res://scenes/flower.tscn")
var active_item: PlayerItem = null
# TODO: Can items overlap? Should we solve that when dropping items?
var last_colliding_item: PlayerItem = null

onready var planting_area := $PlantingArea as Area2D

#sounds
onready var walking_sounds := $WalkingSounds as OneShotPlayer
onready var motyka_sounds := $MotykaSounds as OneShotPlayer
onready var pickup_sound := $PickupSound as AudioStreamPlayer2D
onready var nejde_sound := $ToNejdeSound as AudioStreamPlayer2D


func _ready():
	pass

func _process(delta: float):
	apply_movement(delta)

	if last_colliding_item is PlayerItem and Input.is_action_just_pressed("secondary"):
		swap_items()

	if active_item != null:
		active_item.position = position

	if active_item != null and Input.is_action_just_pressed("primary"):
		use_active_item()

func _on_Player_area_entered(area):
	if area is PlayerItem:
		last_colliding_item = area
		# var item = area as PlayerItem
		# print_debug("Item type: %s" % item.type)

func _on_Player_area_exited(area):
	if area is PlayerItem:
		last_colliding_item = null

func use_active_item():
	match active_item.type:
		PlayerItem.Type.FlowerBox:
			spawn_plant()
		PlayerItem.Type.Hoe:
			var current_overlapping_weed: Weed = get_first_overlapping_area_in_group("weed")
			if current_overlapping_weed == null:
				return
			current_overlapping_weed.hit()
			motyka_sounds.play()
			
			

func spawn_plant():
	if not can_plant():
		print_debug("Cannot plant, nice")
		nejde_sound.play()
		return
	var flower = flower_scene.instance()
	flower.position = position
	var root = get_node("/root")
	root.add_child(flower)
	root.move_child(flower, 0)
	
	

func swap_items():
	# TODO: Unparent currently active item
	active_item = last_colliding_item
	last_colliding_item = null
	pickup_sound.play()
	

func apply_movement(delta: float):
	var input = Vector2.ZERO
	if Input.is_action_pressed("left"):
		input.x = -speed
		
	if Input.is_action_pressed("right"):
		input.x = speed

	if input.length() > 0 and not walking_sounds.playing:
		walking_sounds.play()
		
		
	position += input * speed * delta

func can_plant():
	# TODO: Prevent when overlapping weed
	return not is_currently_overlapping_node_in_group("flower") and not is_currently_overlapping_node_in_group("weed")

func is_currently_overlapping_node_in_group(group_name: String):
	# var overlapping_areas = planting_area.get_overlapping_areas()
	# for area in overlapping_areas:
	# 	if group_name in area.get_groups():
	# 		return true
	# return false
	return get_first_overlapping_area_in_group(group_name) != null

func get_first_overlapping_area_in_group(group_name: String):
	var overlapping_areas = planting_area.get_overlapping_areas()
	for area in overlapping_areas:
		if group_name in area.get_groups():
			return area
			
	return null

