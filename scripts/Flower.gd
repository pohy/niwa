class_name Flower
extends Area2D

export(Array, Texture) var growth_textures
export var wilted_texture: Texture

onready var ray_cast := $RayCast2D as RayCast2D
onready var sprite := $Sprite as Sprite
onready var growth_timer := $GrowthTimer as Timer

var placed: bool = false
var current_growth_stage: int = 0

func _ready():
	# TODO: Throw when no growth texture is set .empty()
	sprite.visible = false;
	sprite.texture = growth_textures[current_growth_stage]

func _process(delta):
	try_placing_flower()

func _on_GrowthTimer_timeout():
	current_growth_stage += 1
	if current_growth_stage >= growth_textures.size():
		return

	sprite.texture = growth_textures[current_growth_stage]
	growth_timer.start()

func try_placing_flower():
	if placed || ray_cast.get_collider() == null:
		return;

	position = ray_cast.get_collision_point()
	ray_cast.enabled = false
	sprite.visible = true
	placed = true
