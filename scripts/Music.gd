extends Node

onready var loop1 := $Main_music as AudioStreamPlayer
onready var loop2 := $End_music as AudioStreamPlayer
onready var ambient := $Ambient_Sound as AudioStreamPlayer

onready var tween_out = get_node("Tween")

export var transition_duration = 6.00
export var transition_type = 1 # TRANS_SINE

func track_swap():
	fade_out(loop1)
	fade_in(loop2)
	loop2.play()

func ambient_start():
	fade_in(ambient)


func fade_out(loop):
	# tween music volume down to 0
	tween_out.interpolate_property(loop, "volume_db", -6, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
	# when the tween ends, the music will be stopped
	
func fade_in(loop):

	tween_out.interpolate_property(loop, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()


func _on_Tween_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	loop1.stop()
	loop2.volume_db = 0 # reset volume
