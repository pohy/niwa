# Do not try to change the filename case on windows. It will save you some frustration ;)
class_name Weed
extends Area2D

onready var growing_sprite := $GrowingSprite as GrowingSprite

var spawn_position: int
# var weed_spawner: WeedSpawner

func _ready():
	growing_sprite.start_next_stage_growth()

func hit():
	var next_growth_stage = growing_sprite.current_growth_stage - 1
	growing_sprite.update_growth_stage(-1)
	if (next_growth_stage < 0):
		print_debug("Destroy weedling")
		# weed_spawner.free_spawn_position(spawn_position)
		queue_free()


func _on_GrowingSprite_growth_finished():
	for area in get_overlapping_areas():
		if "flower" in area.get_groups():
			var flower: Flower = area
			flower.wilt()
