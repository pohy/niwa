class_name Weed
extends Area2D

onready var growing_sprite := $GrowingSprite as GrowingSprite

func _ready():
	growing_sprite.start_next_stage_growth()
