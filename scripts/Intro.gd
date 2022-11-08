extends Node2D

onready var animation_player := $AnimationPlayer as AnimationPlayer

func _ready():
	animation_player.play("intro")

func load_main():
	get_tree().change_scene("res://scenes/main.tscn")
