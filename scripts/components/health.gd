class_name Health
extends Node

signal changed(new_hp: int, delta: int)
signal died()

@export var max_hp: int = 100

var hp: int

func _ready() -> void:
	hp = max_hp

func set_max_hp(v: int, heal_to_full: bool = true) -> void:
	max_hp = max(1, v)
	if heal_to_full:
		hp = max_hp
		changed.emit(hp, 0)

func apply_damage(amount: int) -> void:
	if amount <= 0 or hp <= 0:
		return
	var old := hp
	hp = max(0, hp - amount)
	changed.emit(hp, hp - old)
	if hp == 0:
		died.emit()
