extends Node


onready var tween_out = get_node("Tween")
onready var wind := $Wind as AudioStreamPlayer

export var transition_duration = 4.00
export var transition_type = 1 # TRANS_SINE


func start_the_show():
	wind.play()
	fade_in(wind)

func fade_in(loop):

	tween_out.interpolate_property(loop, "volume_db", -80, -10, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_out.start()
