## Owns application state and transitions: boot -> menu -> match -> results
extends Node

@export var main_menu_scene: PackedScene
@export var match_scene: PackedScene

var current_scene: Node

func _ready() -> void:
	_show_main_menu()

func _show_main_menu() -> void:
	_switch_to(main_menu_scene.instantiate())

func start_match(params: Dictionary) -> void:
	var match_root := match_scene.instantiate()
	_switch_to(match_root)

func _switch_to(next: Node) -> void:
	if current_scene:
		current_scene.queue_free()
	current_scene = next
	get_tree().root.add_child(current_scene)
