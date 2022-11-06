extends Node

export var music_stage = 1

onready var loop1 := $Main_music as AudioStreamPlayer
onready var loop2 := $End_music as AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# track_counter()

func track_counter():
		if music_stage == 1:
			loop1.play()			
				
		if music_stage == 2:
			loop2.play()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
