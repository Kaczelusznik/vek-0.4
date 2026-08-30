extends Node2D

@onready var pause_menu: Control = $PauseMenu

func _ready() -> void:
	get_tree().paused = false
	pause_menu.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu.close_menu()
		else:
			pause_menu.open_menu()

		get_viewport().set_input_as_handled()
