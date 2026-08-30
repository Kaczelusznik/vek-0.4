extends CanvasLayer

const SETTINGS_FILE := "user://settings.cfg"
const MIN_DB := -45.0
const MAX_DB := -15.0
const DEFAULT_VOLUME_PERCENT := 60.0

@onready var fade_rect: ColorRect = $FadeRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var btn_hover: AudioStreamPlayer2D = $BtnHover
@onready var btn_click: AudioStreamPlayer2D = $BtnClick
@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var pause_menu: Control = $PauseMenu


func _ready() -> void:
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_load_settings_on_start()

	if is_instance_valid(pause_menu):
		pause_menu.hide()
		pause_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if _can_open_pause_menu():
			if get_tree().paused:
				if is_instance_valid(pause_menu):
					pause_menu.close_menu()
			else:
				if is_instance_valid(pause_menu):
					pause_menu.open_menu()
			
			get_viewport().set_input_as_handled()


func _can_open_pause_menu() -> bool:
	var current_scene := get_tree().current_scene
	
	if current_scene == null:
		return false
	
	var scene_path := current_scene.scene_file_path
	
	if scene_path == "res://scenes/MainMenu.tscn":
		return false
	if scene_path == "res://scenes/intro_scene.tscn":
		return false
	if scene_path == "res://scenes/settings_scene.tscn":
		return false
	if scene_path == "res://scenes/saves_scene.tscn":
		return false
	
	return true

func play_hover() -> void:
	btn_hover.play()


func play_click() -> void:
	btn_click.play()


func fade_in() -> void:
	animation_player.play("Fade_in")


func fade_out() -> void:
	animation_player.play("Fade_out")


func change_scene_with_fade(path: String) -> void:
	if is_instance_valid(pause_menu):
		pause_menu.hide()
		pause_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	get_tree().paused = false
	
	animation_player.play("Fade_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	animation_player.play("Fade_out")


func play_menu_music() -> void:
	if not is_instance_valid(menu_music):
		return
	
	if not menu_music.playing:
		menu_music.play()


func stop_menu_music() -> void:
	if not is_instance_valid(menu_music):
		return
	
	if menu_music.playing:
		menu_music.stop()


func _load_settings_on_start() -> void:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_FILE)
	
	var ost_percent: float = DEFAULT_VOLUME_PERCENT
	var sfx_percent: float = DEFAULT_VOLUME_PERCENT
	var fullscreen: bool = false
	
	if err == OK:
		ost_percent = float(config.get_value("audio", "ost_percent", DEFAULT_VOLUME_PERCENT))
		sfx_percent = float(config.get_value("audio", "sfx_percent", DEFAULT_VOLUME_PERCENT))
		fullscreen = bool(config.get_value("video", "fullscreen", false))
	
	var ost_bus_index := AudioServer.get_bus_index("OST")
	var sfx_bus_index := AudioServer.get_bus_index("SFX")
	
	if ost_bus_index != -1:
		AudioServer.set_bus_volume_db(ost_bus_index, _percent_to_db(ost_percent))
	
	if sfx_bus_index != -1:
		AudioServer.set_bus_volume_db(sfx_bus_index, _percent_to_db(sfx_percent))
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _percent_to_db(percent: float) -> float:
	var t: float = clampf(percent / 100.0, 0.0, 1.0)
	return lerpf(MIN_DB, MAX_DB, t)
