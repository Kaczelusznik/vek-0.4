extends Control

const INN_SCENE := "res://scenes/inn_scene.tscn"
const SCROLL_SPEED := 17.0
const TARGET_Y := -4000.0
const CONTINUE_BUTTON_SHOWTIME := 0.0

@onready var text_block: Control = $Text
@onready var continue_button: Button = $ContinueButton
@onready var voice_player: AudioStreamPlayer2D = $VoicePlayerLector
@onready var music_player: AudioStreamPlayer2D = $Music

var intro_finished := false

func _ready() -> void:
	get_tree().paused = false
	GlobalUI.fade_in()
	continue_button.hide()

	if music_player.stream:
		music_player.play()

	if voice_player.stream:
		voice_player.play()

	show_continue_button()
	
func _process(delta: float) -> void:
	if intro_finished:
		return

	if text_block.position.y > TARGET_Y:
		text_block.position.y -= SCROLL_SPEED * delta
	else:
		text_block.position.y = TARGET_Y
		intro_finished = true

func show_continue_button():
	await get_tree().create_timer(CONTINUE_BUTTON_SHOWTIME).timeout
	continue_button.show()

func _on_continue_button_pressed() -> void:
	print("klik dziala")
	GlobalUI.play_click()
	await GlobalUI.change_scene_with_fade(INN_SCENE)

func _on_continue_button_mouse_entered() -> void:
	GlobalUI.play_hover()
