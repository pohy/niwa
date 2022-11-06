extends Node

export var music_stage = 1

onready var loop1 := $Music_Loop_1 as AudioStreamPlayer
onready var loop2 := $Music_Loop_2 as AudioStreamPlayer
onready var counter = 0
onready var music_playing = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	track_counter()

func track_counter():
	while music_playing:
		if music_stage == 1:
			loop1.play()			
			counter += 1
			if counter > 1:
				loop1.stream_paused = true
				music_stage = 2
	
		if music_stage == 2:
			loop2.play()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
