class_name Flower
extends Area2D

export var wilted_texture: Texture

onready var ray_cast := $RayCast2D as RayCast2D
onready var growing_sprite := $GrowingSprite as GrowingSprite
onready var wilted_sprite := $WiltedSprite as Sprite
onready var wilting_player := $WiltingPlayer as AnimationPlayer

var placed: bool = false

func _ready():
	# TODO: Throw when no growth texture is set .empty()
	growing_sprite.visible = false;
	growing_sprite.start_next_stage_growth()

func _process(delta):
	if not placed:
		try_placing_flower()

func try_placing_flower():
	if placed || ray_cast.get_collider() == null:
		return;

	position = ray_cast.get_collision_point()
	ray_cast.enabled = false
	growing_sprite.visible = true
	placed = true

func wilt():
	wilting_player.play("WiltAnimation")
	# growing_sprite.stop_growth()
	growing_sprite.set_process(false)
	growing_sprite.visible = false
	wilted_sprite.visible = true
	print_debug("wilting :(")

