extends Node2D

export var ground_level: float = 400
export var spawn_range: Vector2 = Vector2(0, 1280)
export var spawn_rate_range: Vector2 = Vector2(1, 5)
export var max_weeds: int = 20
export var spawn_positions_jitter: float = 10

onready var spawn_timer := $SpawnTimer as Timer

var weed_scene: PackedScene = preload("res://scenes/weed.tscn")

var existing_weeds = []
# TODO: Remove used position on weed removal
var used_positions = []


func _ready():
	pass

func _on_SpawnTimer_timeout():
	# var flowers = get_tree().get_nodes_in_group("flower")
	# TODO: Track whether the flower has weed already growing for it?
	# print_debug(flowers)
	var weed = weed_scene.instance()
	var next_spawn_position = get_next_spawn_position()
	if next_spawn_position < 0:
		print_debug("TODO: All weed spawn positions exhausted")
		return
	# print_debug("used positions: %s" % String(used_positions))
	var distance_between_spawn_positions = (spawn_range.y / max_weeds)
	weed.position = Vector2(
		# distance_between_spawn_positions / 2 +
			next_spawn_position * distance_between_spawn_positions +
			rand_range(-spawn_positions_jitter, spawn_positions_jitter),
		ground_level
	)
	weed.spawn_position = next_spawn_position
	add_child(weed)
	existing_weeds.append(weed)

	spawn_timer.start(rand_range(spawn_rate_range.x, spawn_rate_range.y))

func get_next_spawn_position(current_min_position: int = 0) -> int:
	# TODO: They still overlap :(
	if current_min_position > max_weeds:
		return int(-1)

	var next_position = int(rand_range(current_min_position, max_weeds))

	if used_positions.has(next_position):
		return get_next_spawn_position(current_min_position + 1)

	used_positions.append(next_position)
	return next_position
