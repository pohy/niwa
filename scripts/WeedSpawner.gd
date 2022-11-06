class_name WeedSpawner
extends Node2D

signal max_weeds_grown

export var ground_level: float = 400
export var spawn_range: Vector2 = Vector2(0, 1280)
export var spawn_rate_range: Vector2 = Vector2(1, 5)
export var spawn_positions_jitter: float = 10

onready var spawn_timer := $SpawnTimer as Timer

var weed_scene: PackedScene = preload("res://scenes/weed.tscn")

var existing_weeds = []
var used_positions = []
var fully_grown_weed_count = 0
var max_weeds = 7

func _ready():
	pass

func _on_SpawnTimer_timeout():
	if get_used_positions().size() >= max_weeds:
		# print_debug("TODO: All weed spawn positions exhausted")
		spawn_timer.stop()
		return

	# var flowers = get_tree().get_nodes_in_group("flower")
	# TODO: Track whether the flower has weed already growing for it?
	# print_debug(flowers)
	var next_spawn_position = get_next_spawn_position()

	if next_spawn_position >= 0:
		# print_debug("Spawning weed at position: %s" % next_spawn_position)
		# print_debug("used positions: %s" % String(used_positions))
		var distance_between_spawn_positions = ((abs(spawn_range.x) + abs(spawn_range.y)) / max_weeds)
		var weed = weed_scene.instance()
		
		# weed.growing_sprite.spawn_rate_range = Vector2()
		
		
		weed.position = Vector2(
			# distance_between_spawn_positions / 2 +
				spawn_range.x +
				next_spawn_position * distance_between_spawn_positions +
				rand_range(-spawn_positions_jitter, spawn_positions_jitter),
			ground_level
		)
		weed.spawn_position = next_spawn_position
		weed.connect("tree_exiting", self, "_on_Weed_tree_exiting", [next_spawn_position, weed])
		weed.connect("grown", self, "_on_Weed_grown")
		# weed.weed_spawner = self
		add_child(weed)
		existing_weeds.append(weed)

	spawn_timer.start(rand_range(spawn_rate_range.x, spawn_rate_range.y))

func _on_Weed_tree_exiting(spawn_position: int, weed: Weed):
	# print_debug("Freeing spawn pos: %s" % spawn_position)
	used_positions.erase(spawn_position)
	fully_grown_weed_count -= 1
	# print_debug(get_used_positions())
	print_debug("weeds grown: %s" % fully_grown_weed_count)
	existing_weeds.erase(weed)
	if spawn_timer.is_stopped():
		spawn_timer.start()

func _on_Weed_grown():
	fully_grown_weed_count += 1
	print_debug("weeds grown: %s" % fully_grown_weed_count)
	# TODO: -1 is a hack, let's not change the weed count from 7, or rather, to an even number :)
	if fully_grown_weed_count >= max_weeds - 1:
		start_end_game()

func get_next_spawn_position(current_min_position: int = 0) -> int:
	var already_used_positions = get_used_positions()
	# print_debug("size: %s, used: %s" % [already_used_positions.size(), already_used_positions])
	if already_used_positions.size() >= max_weeds:
		return -1

	var next_position = int(rand_range(current_min_position, max_weeds))

	if next_position in already_used_positions:
		for i in range(0, max_weeds - 1):
			if not already_used_positions.has(i):
				# print_debug("Returning i: %s" % i)
				used_positions.append(i)
				return i
		return -1

	used_positions.append(next_position)
	return next_position

func get_used_positions():
	var is_odd = max_weeds % 2 != 0
	var mid_position = [int(floor(max_weeds / 2.0))] if is_odd else [max_weeds / 2, max_weeds / 2 + 1]
	var new_used_positions = [] + used_positions
	new_used_positions.append_array(mid_position)
	# print_debug(new_used_positions)
	return new_used_positions

func swap_weeds():
	for weed in existing_weeds:
		weed.swap_to_color()

func _on_DelayTimer_timeout():
	spawn_timer.start()

	# start_end_game()

func start_end_game():
	# fully_grown_weed_count = max_weeds

	emit_signal("max_weeds_grown")
	spawn_timer.stop()


var spawn_counter = 0

func _on_SpawnSpeedTimer_timeout():
	
	spawn_counter += 1
	
	if spawn_counter == 1:
		spawn_rate_range = Vector2(4,6)
		
	if spawn_counter == 2:
		spawn_rate_range = Vector2(3,5)
		
	if spawn_counter == 3:
		spawn_rate_range = Vector2(3,4)
		
	if spawn_counter == 5:
		spawn_rate_range = Vector2(2,4)
	
	if spawn_counter == 6:
		spawn_rate_range = Vector2(2,2)
		
	if spawn_counter == 7:
		spawn_rate_range = Vector2(1,1)
	
	if spawn_counter == 8:
		spawn_rate_range = Vector2(0.5,0.5)
