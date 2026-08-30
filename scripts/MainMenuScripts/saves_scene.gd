extends Control

const MAIN_MENU_SCENE := "res://scenes/MainMenu.tscn"

@onready var slot_1: Button = $Panel/MenuBox/Slot1
@onready var slot_2: Button = $Panel/MenuBox/Slot2
@onready var slot_3: Button = $Panel/MenuBox/Slot3
@onready var back: Button = $Panel/MenuBox/Back

func _ready() -> void:
	GlobalUI.fade_out()
	GlobalUI.play_menu_music()
	_connect_hover_signals()
	

func _connect_hover_signals() -> void:
	slot_1.mouse_entered.connect(_on_any_button_mouse_entered)
	slot_2.mouse_entered.connect(_on_any_button_mouse_entered)
	slot_3.mouse_entered.connect(_on_any_button_mouse_entered)
	back.mouse_entered.connect(_on_any_button_mouse_entered)
	
func _on_any_button_mouse_entered() -> void:
	GlobalUI.play_hover()
	
func _on_slot_1_pressed() -> void:
	GlobalUI.play_click()
	print("Slot 1 is empty")

func _on_slot_2_pressed() -> void:
	GlobalUI.play_click()
	print("Slot 2 is empty")

func _on_slot_3_pressed() -> void:
	GlobalUI.play_click()
	print("Slot 3 is empty")

func _on_back_pressed() -> void:
	GlobalUI.play_click()
	await GlobalUI.change_scene_with_fade(MAIN_MENU_SCENE)
