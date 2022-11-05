class_name WeedSpawner
extends Node2D

export var ground_level: float = 400
export var spawn_range: Vector2 = Vector2(0, 1280)
export var spawn_rate_range: Vector2 = Vector2(1, 5)
export var max_weeds: int = 20
export var spawn_positions_jitter: float = 10

onready var spawn_timer := $SpawnTimer as Timer

var weed_scene: PackedScene = preload("res://scenes/weed.tscn")

var existing_weeds = []
var used_positions = []


func _ready():
	pass

func _on_SpawnTimer_timeout():
	if used_positions.size() >= max_weeds:
		print_debug("TODO: All weed spawn positions exhausted")
		spawn_timer.stop()
		return

	# var flowers = get_tree().get_nodes_in_group("flower")
	# TODO: Track whether the flower has weed already growing for it?
	# print_debug(flowers)
	var next_spawn_position = get_next_spawn_position()

	if next_spawn_position >= 0:
		print_debug("Spawning weed at position: %s" % next_spawn_position)
		# print_debug("used positions: %s" % String(used_positions))
		var distance_between_spawn_positions = (spawn_range.y / max_weeds)
		var weed = weed_scene.instance()
		weed.position = Vector2(
			# distance_between_spawn_positions / 2 +
				next_spawn_position * distance_between_spawn_positions +
				rand_range(-spawn_positions_jitter, spawn_positions_jitter),
			ground_level
		)
		weed.spawn_position = next_spawn_position
		weed.connect("tree_exiting", self, "_on_Weed_tree_exiting", [next_spawn_position])
		# weed.weed_spawner = self
		add_child(weed)
		existing_weeds.append(weed)

	spawn_timer.start(rand_range(spawn_rate_range.x, spawn_rate_range.y))

func _on_Weed_tree_exiting(spawn_position: int):
	print_debug("Freeing spawn pos: %s" % spawn_position)
	used_positions.erase(spawn_position)
	print_debug(used_positions)
	if spawn_timer.is_stopped():
		spawn_timer.start()

func get_next_spawn_position(current_min_position: int = 0) -> int:
	if used_positions.size() >= max_weeds:
		return -1

	var next_position = int(rand_range(current_min_position, max_weeds))

	if next_position in used_positions:
		for i in range(0, max_weeds - 1):
			if not used_positions.has(i):
				print_debug("Returning i: %s" % i)
				used_positions.append(i)
				return i
		return -1

	used_positions.append(next_position)
	return next_position
