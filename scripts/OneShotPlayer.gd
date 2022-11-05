class_name OneShotPlayer
extends Node

export(Array, AudioStreamSample) var samples
export var playing = false

onready var audio_player := $AudioStreamPlayer2D as AudioStreamPlayer2D

var should_continue_playing = false
var sample_index = -1

func _process(delta):
	playing = audio_player.playing

func _on_AudioStreamPlayer2D_finished():
	if not should_continue_playing:
		return

	play_immediately()

func play():
	if audio_player.playing:
		should_continue_playing = true
		return

	play_immediately()

func play_immediately():
	sample_index = get_next_index()
	audio_player.stream = samples[sample_index]
	audio_player.play()
	should_continue_playing = false

func stop():
	should_continue_playing = false
	audio_player.stop()

func get_next_index():
	var next_index = sample_index + 1
	# Restart to the first sample
	next_index = next_index if next_index < samples.size() else 0
	return next_index

