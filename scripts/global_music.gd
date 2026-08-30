extends Node

var player: AudioStreamPlayer

func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)

func play_music(stream: AudioStream) -> void:
	if player.stream == stream and player.playing:
		return

	player.stream = stream
	player.play()

func stop_music() -> void:
	player.stop()
