extends Control

const MAIN_MENU_SCENE := "res://scenes/MainMenu.tscn"

@onready var resume_button: Button = $LeftPanel/MenuBox/Resume
@onready var save_button: Button = $LeftPanel/MenuBox/SaveGame
@onready var load_button: Button = $LeftPanel/MenuBox/LoadGame
@onready var settings_button: Button = $LeftPanel/MenuBox/SettingsButton
@onready var main_menu_button: Button = $LeftPanel/MenuBox/MainMenuButton

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_connect_signals()

func _connect_signals() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

	resume_button.mouse_entered.connect(_on_any_button_mouse_entered)
	save_button.mouse_entered.connect(_on_any_button_mouse_entered)
	load_button.mouse_entered.connect(_on_any_button_mouse_entered)
	settings_button.mouse_entered.connect(_on_any_button_mouse_entered)
	main_menu_button.mouse_entered.connect(_on_any_button_mouse_entered)

func open_menu() -> void:
	show()
	mouse_filter = Control.MOUSE_FILTER_STOP

func close_menu() -> void:
	hide()
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_any_button_mouse_entered() -> void:
	GlobalUI.play_hover()

func _on_resume_pressed() -> void:
	GlobalUI.play_click()
	close_menu()

func _on_save_pressed() -> void:
	GlobalUI.play_click()
	print("Save Game not implemented yet")

func _on_load_pressed() -> void:
	GlobalUI.play_click()
	print("Load Game not implemented yet")

func _on_settings_pressed() -> void:
	GlobalUI.play_click()
	print("Pause settings not implemented yet")

func _on_main_menu_pressed() -> void:
	GlobalUI.play_click()
	close_menu()
	GlobalUI.stop_menu_music()
	await GlobalUI.change_scene_with_fade(MAIN_MENU_SCENE)
