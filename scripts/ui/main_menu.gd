extends Control

@export var options_menu_scene: PackedScene

#func _on_start_pressed() -> void:
	#Game.start_match({})

func _on_options_pressed() -> void:
	var options := options_menu_scene.instantiate()
	add_child(options)
	(options as Control).set_anchors_preset(Control.PRESET_FULL_RECT)

func _on_quit_pressed() -> void:
	get_tree().quit()
