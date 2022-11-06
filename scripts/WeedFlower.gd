# Do not try to change the filename case on windows. It will save you some frustration ;)
class_name Weed
extends Area2D

signal grown


onready var growing_sprite := $GrowingSprite as GrowingSprite

var flowers = []
var spawn_position: int
var invincible: bool = false
# var weed_spawner: WeedSpawner

func _ready():
	growing_sprite.start_next_stage_growth()
	flowers.append($"Flowers/Flower1")
	flowers.append($"Flowers/Flower2")
	flowers.append($"Flowers/Flower3")
	for flower in flowers:
		flower.stop_growth()
	print_debug(flowers)

func hit():
	if invincible:
		return

	var next_growth_stage = growing_sprite.current_growth_stage - 1
	growing_sprite.update_growth_stage(-1)
	if (next_growth_stage < 0):
		print_debug("Destroy weedling")
		# weed_spawner.free_spawn_position(spawn_position)
		queue_free()


func _on_GrowingSprite_growth_finished():
	emit_signal("grown")
	for area in get_overlapping_areas():
		if "flower" in area.get_groups():
			var flower: Flower = area
			flower.wilt()

func swap_to_color():
	growing_sprite.visible = false
	var flower_index = rand_range(0, flowers.size())
	var flower: GrowingSprite = flowers[flower_index]
	flower.visible = true
	flower.growth_timer.start()
	scale = Vector2.ONE * rand_range(1, 1.7)
	invincible = true
