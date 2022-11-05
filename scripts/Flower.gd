class_name Flower
extends Area2D

onready var ray_cast := $RayCast2D as RayCast2D
onready var sprite := $Sprite as Sprite

var placed: bool = false

func _ready():
	sprite.visible = false
	var pos = ray_cast.get_collision_point()
	print_debug(ray_cast.get_collider())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !placed and ray_cast.get_collider() != null:
		position = ray_cast.get_collision_point()
		ray_cast.enabled = false
		sprite.visible = true
		placed = true
