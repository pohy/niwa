extends Node

onready var fog := $Fog as AnimatedSprite
onready var weed_spawner := $"../WeedSpawner" as WeedSpawner
onready var player := $"../Player" as Player
onready var exit_music := $ExitMusic as AudioStreamPlayer

var end_game_started = false
var end_game_finished = false

func _ready():
	randomize()

func _on_Fog_animation_finished():
	print_debug("fog finished")
	match fog.animation:
		"fade_out":
			weed_spawner.swap_weeds()
			fog.play("fade_in")
		"fade_in":
			fog.visible = false
			player.controllable = true
	pass # Replace with function body.


func _on_WeedSpawner_max_weeds_grown():
	# TODO: Move the player somewhere in the air?
	if end_game_started:
		return
	end_game_started = true
	print_debug("all weeds grown GAME \"OVER\"")
	player.disable()
	fog.visible = true
	fog.play("fade_out")
	
	exit_music.play()
	
	
