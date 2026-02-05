extends CanvasLayer

signal retry_pressed()
signal main_menu_pressed()

@onready var root: Control = $Root

@onready var title_lbl: Label = %Title
@onready var subtitle_lbl: Label = %Subtitle
@onready var time_lbl: Label = %TimeSurvived

@onready var retry_btn: Button = %RetryButton
@onready var main_menu_btn: Button = %MainMenuButton


func _enter_tree() -> void:
	if is_instance_valid(root):
		root.visible = false
		root.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	root.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	retry_btn.pressed.connect(func(): retry_pressed.emit())
	main_menu_btn.pressed.connect(func(): main_menu_pressed.emit())

	_set_default_text()
	hide_ui()


func _set_default_text() -> void:
	title_lbl.text = ""
	subtitle_lbl.text = ""
	time_lbl.text = ""


func show_result(
	victory: bool,
	subtitle: String = "",
	time_survived_seconds: float = -1.0
) -> void:
	show_ui()

	title_lbl.text = "Victory!" if victory else "Defeat"
	subtitle_lbl.text = subtitle

	if time_survived_seconds >= 0.0:
		time_lbl.visible = true
		time_lbl.text = "Time survived: %s" % _format_time(time_survived_seconds)
	else:
		time_lbl.visible = false
		time_lbl.text = ""

	call_deferred("_focus_retry")


func hide_ui() -> void:
	root.visible = false
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE


func show_ui() -> void:
	root.visible = true
	root.mouse_filter = Control.MOUSE_FILTER_STOP


func _focus_retry() -> void:
	retry_btn.grab_focus()


func _format_time(seconds: float) -> String:
	var total := int(floor(seconds))
	var mins := total / 60
	var secs := total % 60
	return "%02d:%02d" % [mins, secs]
