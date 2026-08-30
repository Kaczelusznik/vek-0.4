extends Control

const INTRO_SCENE := "res://scenes/intro_scene.tscn"
const SETTINGS_SCENE := "res://scenes/settings_scene.tscn"
const SAVES_SCENE := "res://scenes/saves_scene.tscn"

@onready var new_game: Button = $LeftPanel/MenuBox/NewGame
@onready var load_game: Button = $LeftPanel/MenuBox/LoadGame
@onready var settings_button: Button = $LeftPanel/MenuBox/SettingsButton
@onready var exit_button: Button = $LeftPanel/MenuBox/ExitButton

func _ready() -> void:
	GlobalUI.fade_out()
	GlobalUI.play_menu_music()
	_connect_button_signals()

func _connect_button_signals() -> void:
	new_game.mouse_entered.connect(_on_any_button_mouse_entered)
	load_game.mouse_entered.connect(_on_any_button_mouse_entered)
	settings_button.mouse_entered.connect(_on_any_button_mouse_entered)
	exit_button.mouse_entered.connect(_on_any_button_mouse_entered)

func _on_any_button_mouse_entered() -> void:
	GlobalUI.play_hover()

func _on_new_game_pressed() -> void:
	GlobalUI.play_click()
	GlobalUI.stop_menu_music()
	await GlobalUI.change_scene_with_fade(INTRO_SCENE)

func _on_load_game_pressed() -> void:
	GlobalUI.play_click()
	await GlobalUI.change_scene_with_fade(SAVES_SCENE)

func _on_settings_pressed() -> void:
	GlobalUI.play_click()
	await GlobalUI.change_scene_with_fade(SETTINGS_SCENE)

func _on_exit_pressed() -> void:
	GlobalUI.play_click()
	get_tree().quit()
