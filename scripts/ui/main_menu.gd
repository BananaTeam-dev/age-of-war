extends Control

@onready var start_btn: Button = %Start
@onready var options_btn: Button = %Options
@onready var quit_btn: Button = %Quit

func _ready() -> void:
	start_btn.pressed.connect(_on_start_pressed)
	options_btn.pressed.connect(_on_options_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	print("Start pressed -> emitting match_started")
	Events.match_started.emit()

func _on_options_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
