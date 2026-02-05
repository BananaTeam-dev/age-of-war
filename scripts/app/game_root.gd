## Owns application state and transitions: boot -> menu -> match -> results
extends Node

@export var main_menu_scene: PackedScene
@export var match_scene: PackedScene

var current: Node
@onready var host: Node = $SceneHost

func _ready() -> void:
	Events.match_started.connect(_on_match_started)
	Events.main_menu_requested.connect(_on_main_menu_requested)
	_switch_to(main_menu_scene)

func _on_match_started() -> void:
	_switch_to(match_scene)

func _on_main_menu_requested() -> void:
	_switch_to(main_menu_scene)

func _switch_to(scene: PackedScene) -> void:
	get_tree().paused = false

	if current and is_instance_valid(current):
		current.queue_free()
		current = null

	current = scene.instantiate()
	host.add_child(current)
	
