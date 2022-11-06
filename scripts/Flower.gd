class_name Flower
extends Area2D

export var wilted_texture: Texture

onready var ray_cast := $RayCast2D as RayCast2D
# onready var growing_sprite := $Flower/GrowingSprite as GrowingSprite
# onready var wilted_sprite := $Flower/WiltedSprite as Sprite
var growing_sprite: GrowingSprite
var wilted_sprite: Sprite
onready var wilting_player := $WiltingPlayer as AnimationPlayer

var placed: bool = false
var active_flower: Node2D

func _ready():
	var available_flowers = []
	available_flowers.append($"Flowers/Flower1")
	available_flowers.append($"Flowers/Flower2")
	available_flowers.append($"Flowers/Flower3")

	active_flower = available_flowers[rand_range(0, available_flowers.size() - 1)]
	growing_sprite = active_flower.get_node("GrowingSprite")
	wilted_sprite = active_flower.get_node("WiltedSprite")

	print_debug(growing_sprite)
	print_debug(wilted_sprite)

	active_flower.visible = true
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

