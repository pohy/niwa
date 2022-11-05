extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed: float = 20

var flower_scene: PackedScene = preload("res://scenes/flower.tscn")
var active_item: PlayerItem = null
# TODO: Can items overlap? Should we solve that when dropping items?
var last_colliding_item: PlayerItem = null

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

func use_active_item():
	match active_item.type:
		PlayerItem.Type.FlowerBox:
			# TODO: Check whether there is room for the plant to be planted
			var flower = flower_scene.instance()
			flower.position = position
			get_node("/root").add_child(flower)

func swap_items():
	# TODO: Unparent currently active item
	active_item = last_colliding_item
	last_colliding_item = null

func apply_movement(delta: float):
	var input = Vector2.ZERO
	if Input.is_action_pressed("left"):
		input.x = -speed
	if Input.is_action_pressed("right"):
		input.x = speed
		
	position += input * speed * delta

func _on_Player_area_entered(area):
	if area is PlayerItem:
		last_colliding_item = area
		# var item = area as PlayerItem
		# print_debug("Item type: %s" % item.type)

func _on_Player_area_exited(area):
	if area is PlayerItem:
		last_colliding_item = null
