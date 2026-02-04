class_name UpgradeDef
extends Resource

@export var id: StringName
@export var display_name: String
@export var cost: int = 100

## Applies to all units with these tags (empty => all).
@export var applies_to_tags: Array[StringName] = []

@export var modifiers: Array[StatModifier] = []
