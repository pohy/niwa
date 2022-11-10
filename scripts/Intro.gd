extends Node2D

var main_scene: PackedScene = preload("res://scenes/main.tscn")

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var ambient_wind := $AmbientSound

func _ready():
	animation_player.play("intro")
	
	ambient_wind.start_the_show()

func load_main():
	get_tree().change_scene_to(main_scene)
