extends Node

# TODO: Disable player and move them somewhere in the air
onready var fog := $Fog as AnimatedSprite
onready var weed_spawner := $"../WeedSpawner" as WeedSpawner
onready var player := $"../Player" as Player
onready var exit_music := $ExitMusic as AudioStreamPlayer

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
	print_debug("all weeds grown GAME")
	player.controllable = false
	fog.visible = true
	fog.play("fade_out")
	
	exit_music.play()
	
	
