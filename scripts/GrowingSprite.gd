tool
class_name GrowingSprite
extends Node2D

signal growth_finished

export(Array, Texture) var growth_textures
export var growth_time_range: Vector2 = Vector2(5, 7)

onready var sprite := $Sprite as Sprite
onready var growth_timer := $GrowthTimer as Timer

var current_growth_stage: int = 0

func _ready():
	sprite.texture = growth_textures[current_growth_stage]

func _on_GrowthTimer_timeout():
	update_growth_stage(1)

func start_next_stage_growth():
	if current_growth_stage >= growth_textures.size():
		return
	growth_timer.start()

func revert_growth_stage():
	if current_growth_stage <= 0:
		return
	growth_timer.stop()
	update_growth_stage(-1)

func update_growth_stage(addition: int):
	var next_growth_stage = current_growth_stage + addition
	# print_debug("next growth stage: %s, sprite size: %s" % [next_growth_stage, growth_textures.size()])
	if next_growth_stage < 0:
		return
	
	print_debug("next: %s, growth count: %s, is grown: %s" % [next_growth_stage, growth_textures.size(), is_grown()])
	if next_growth_stage >= growth_textures.size(): # is_grown():
		return

	current_growth_stage = next_growth_stage
	sprite.texture = growth_textures[current_growth_stage]
	growth_timer.start(rand_range(growth_time_range.x, growth_time_range.y))

	if is_grown():
		emit_signal("growth_finished")

func stop_growth():
	growth_timer.stop()

func is_grown() -> bool:
	return current_growth_stage >= growth_textures.size() - 1

