extends CanvasLayer

@onready var root: Control = $Root
@onready var resume_btn: Button = %ResumeButton
@onready var main_menu_btn: Button = %MainMenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	root.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	resume_btn.pressed.connect(func():
		Events.paused_changed.emit(false)
	)

	main_menu_btn.pressed.connect(func():
		Events.paused_changed.emit(false)
		Events.main_menu_requested.emit()
	)

	hide_menu()

func _unhandled_input(event: InputEvent) -> void:
	if root.visible and event.is_action_pressed("ui_cancel"):
		Events.paused_changed.emit(false)
		get_viewport().set_input_as_handled()

func show_menu() -> void:
	root.visible = true

func hide_menu() -> void:
	root.visible = false
