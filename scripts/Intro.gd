extends Node2D

var main_scene: PackedScene = preload("res://scenes/main.tscn")

onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready():
	animation_player.play("intro")

func load_main():
	get_tree().change_scene_to(main_scene)
