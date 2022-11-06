extends Area2D

export var speed: float = 20
export var min_plant_distance: float = 8

var flower_scene: PackedScene = preload("res://scenes/flower.tscn")
var active_item: PlayerItem = null
# TODO: Can items overlap? Should we solve that when dropping items?
var last_colliding_item: PlayerItem = null

onready var planting_area := $PlantingArea as Area2D

#sounds
onready var walking_sounds := $Sounds/WalkingSounds as OneShotPlayer
onready var motyka_sounds := $Sounds/MotykaSounds as OneShotPlayer
onready var pickup_sound := $Sounds/PickupSound as AudioStreamPlayer2D
onready var nejde_sound := $Sounds/ToNejdeSound as AudioStreamPlayer2D
onready var zasazeni_sound := $Sounds/ZasazeniSound as AudioStreamPlayer2D


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

	var root = get_node("/root")
	root.add_child(flower)
	root.move_child(flower, 0)

	active_item.use()
	zasazeni_sound.play()
	
	
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
	return not Util.is_currently_overlapping_node_in_group(planting_area, "flower") and not Util.is_currently_overlapping_node_in_group(planting_area, "weed")

func is_by_well():
	var overlaps_well = Util.is_currently_overlapping_node_in_group(self, "well")
	print_debug("Overlaps well: %s" % overlaps_well)
	return overlaps_well

# func is_currently_overlapping_node_in_group(group_name: String):
# 	# var overlapping_areas = planting_area.get_overlapping_areas()
# 	# for area in overlapping_areas:
# 	# 	if group_name in area.get_groups():
# 	# 		return true
# 	# return false
# 	return get_first_overlapping_area_in_group(group_name) != null

# func get_first_overlapping_area_in_group(group_name: String):
# 	var overlapping_areas = planting_area.get_overlapping_areas()
# 	for area in overlapping_areas:
# 		if group_name in area.get_groups():
# 			return area
			
# 	return null

