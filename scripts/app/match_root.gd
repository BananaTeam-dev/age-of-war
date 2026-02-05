extends Node

@onready var pause_menu := $UI/PauseMenu

func _ready() -> void:
	Events.paused_changed.connect(_on_paused_changed)
	_on_paused_changed(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not get_tree().paused:
		Events.paused_changed.emit(true)
		get_viewport().set_input_as_handled()

func _on_paused_changed(paused: bool) -> void:
	get_tree().paused = paused
	if paused:
		pause_menu.show_menu()
	else:
		pause_menu.hide_menu()
