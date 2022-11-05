class_name GrowingSprite
extends Node2D

export(Array, Texture) var growth_textures
export var growth_time_range: Vector2 = Vector2(1, 5)

onready var sprite := $Sprite as Sprite
onready var growth_timer := $GrowthTimer as Timer

var current_growth_stage: int = 0

func _ready():
	sprite.texture = growth_textures[current_growth_stage]

func _on_GrowthTimer_timeout():
	update_growth_stage(1)
	# current_growth_stage += 1
	# if current_growth_stage >= growth_textures.size():
	# 	# TODO: Emit a signal that the growy ting has reached its final stage
	# 	return

	# # TODO: Emit signal that a stage has been reached
	# sprite.texture = growth_textures[current_growth_stage]
	# growth_timer.start(rand_range(growth_time_range.x, growth_time_range.y))

# TODO: Expose a method to start growing the next stage
# TODO: Maybe accept min,max growth time
func start_next_stage_growth():
	if current_growth_stage >= growth_textures.size():
		return
	growth_timer.start()

func revert_growth_stage():
	# TODO: Restart growth timer
	if current_growth_stage <= 0:
		return
	growth_timer.stop()
	update_growth_stage(-1)

func update_growth_stage(addition: int):
	var next_growth_stage = current_growth_stage + addition
	print_debug("next growth stage: %s" % next_growth_stage)
	# TODO: Really >= ?
	if next_growth_stage < 0 or next_growth_stage >= growth_textures.size():
		# TODO: Emit a signal that the growy ting has reached its final stage
		return

	current_growth_stage = next_growth_stage
	# TODO: Emit signal that a stage has been reached
	sprite.texture = growth_textures[current_growth_stage]
	growth_timer.start(rand_range(growth_time_range.x, growth_time_range.y))
