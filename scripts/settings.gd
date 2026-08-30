extends Control

const MAIN_MENU_SCENE := "res://scenes/MainMenu.tscn"
const SETTINGS_FILE := "user://settings.cfg"

const MIN_DB := -45.0
const MAX_DB := -15.0
const DEFAULT_VOLUME_PERCENT := 60.0

@onready var ost_slider: HSlider = $Panel/MenuBox/OstSlider
@onready var sfx_slider: HSlider = $Panel/MenuBox/SfxSlider
@onready var fullscreen_toggle: CheckBox = $Panel/MenuBox/FullscreenToggle
@onready var back_button: Button = $Panel/MenuBox/Back

var ost_bus_index := AudioServer.get_bus_index("OST")
var sfx_bus_index := AudioServer.get_bus_index("SFX")

func _ready() -> void:
	GlobalUI.fade_out()
	GlobalUI.play_menu_music()
	_connect_signals()
	_load_settings()

func _connect_signals() -> void:
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(_on_any_button_mouse_entered)
	fullscreen_toggle.mouse_entered.connect(_on_any_button_mouse_entered)

func _on_any_button_mouse_entered() -> void:
	GlobalUI.play_hover()

func _on_back_pressed() -> void:
	GlobalUI.play_click()
	await GlobalUI.change_scene_with_fade(MAIN_MENU_SCENE)

func _on_ost_slider_value_changed(value: float) -> void:
	if ost_bus_index != -1:
		AudioServer.set_bus_volume_db(ost_bus_index, percent_to_db(value))
	_save_settings()

func _on_sfx_slider_value_changed(value: float) -> void:
	if sfx_bus_index != -1:
		AudioServer.set_bus_volume_db(sfx_bus_index, percent_to_db(value))
	_save_settings()

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	GlobalUI.play_click()

	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	_save_settings()

func percent_to_db(percent: float) -> float:
	var t: float = clampf(percent / 100.0, 0.0, 1.0)
	return lerpf(MIN_DB, MAX_DB, t)

func db_to_percent(db: float) -> float:
	var t: float = inverse_lerp(MIN_DB, MAX_DB, clampf(db, MIN_DB, MAX_DB))
	return t * 100.0

func _save_settings() -> void:
	var config := ConfigFile.new()

	config.set_value("audio", "ost_percent", ost_slider.value)
	config.set_value("audio", "sfx_percent", sfx_slider.value)
	config.set_value("video", "fullscreen", fullscreen_toggle.button_pressed)

	config.save(SETTINGS_FILE)

func _load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_FILE)

	if err != OK:
		ost_slider.value = DEFAULT_VOLUME_PERCENT
		sfx_slider.value = DEFAULT_VOLUME_PERCENT
		fullscreen_toggle.button_pressed = false
	else:
		ost_slider.value = float(config.get_value("audio", "ost_percent", DEFAULT_VOLUME_PERCENT))
		sfx_slider.value = float(config.get_value("audio", "sfx_percent", DEFAULT_VOLUME_PERCENT))
		fullscreen_toggle.button_pressed = bool(config.get_value("video", "fullscreen", false))

	if ost_bus_index != -1:
		AudioServer.set_bus_volume_db(ost_bus_index, percent_to_db(ost_slider.value))

	if sfx_bus_index != -1:
		AudioServer.set_bus_volume_db(sfx_bus_index, percent_to_db(sfx_slider.value))

	if fullscreen_toggle.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
