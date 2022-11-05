# Do not try to change the filename case on windows. It will save you some frustration ;)
class_name Weed
extends Area2D

onready var growing_sprite := $GrowingSprite as GrowingSprite

var spawn_position: int

func _ready():
	growing_sprite.start_next_stage_growth()

func hit():
	growing_sprite.update_growth_stage(-1)
	if (growing_sprite.current_growth_stage <= 0):
		print_debug("Destroy weedling")
		queue_free()
