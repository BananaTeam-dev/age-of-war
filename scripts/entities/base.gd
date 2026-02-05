extends Node2D

@export var team_id: int = 0

@onready var health: Health = $Health

func _ready() -> void:
	health.changed.connect(_on_hp_changed)
	health.died.connect(_on_died)

func _on_hp_changed(new_hp: int, delta: int) -> void:
	Events.base_hp_changed.emit(team_id, new_hp, delta)

func _on_died() -> void:
	Events.match_ended.emit(team_id != 0)
