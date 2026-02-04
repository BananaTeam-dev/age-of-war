class_name StatModifier
extends Resource

## Which stat to modify.
@export var stat: StatId.UnitStat

## Flat add (applied before multiplication).
@export var add: float = 0.0

## Multiplicative factor (1.0 = no change).
@export var mul: float = 1.0
