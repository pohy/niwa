extends Node2D

export var ground_level: float = 400
export var spawn_range: Vector2 = Vector2(0, 1280)
export var spawn_rate_range: Vector2 = Vector2(1, 5)

onready var spawn_timer := $SpawnTimer as Timer

var weed_scene: PackedScene = preload("res://scenes/weed.tscn")

func _ready():
	pass # Replace with function body.


func _on_SpawnTimer_timeout():
	# var flowers = get_tree().get_nodes_in_group("flower")
	# TODO: Track whether the flower has weed already growing for it?
	# print_debug(flowers)
	var weed = weed_scene.instance()
	weed.position = Vector2(rand_range(spawn_range.x, spawn_range.y), ground_level)
	add_child(weed)

	spawn_timer.start(rand_range(spawn_rate_range.x, spawn_rate_range.y))
