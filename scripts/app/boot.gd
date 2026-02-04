extends Node

@export var main_menu_scene: PackedScene

func _ready() -> void:
	await get_tree().process_frame
	get_tree().change_scene_to_packed(main_menu_scene)
