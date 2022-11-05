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
	current_growth_stage += 1
	if current_growth_stage >= growth_textures.size():
		# TODO: Emit a signal that the growy ting has reached its final stage
		return

	# TODO: Emit signal that a stage has been reached
	sprite.texture = growth_textures[current_growth_stage]
	growth_timer.start(rand_range(growth_time_range.x, growth_time_range.y))

# TODO: Expose a method to start growing the next stage
# TODO: Maybe accept min,max growth time
func start_next_stage_growth():
	if current_growth_stage >= growth_textures.size():
		return
	growth_timer.start()
