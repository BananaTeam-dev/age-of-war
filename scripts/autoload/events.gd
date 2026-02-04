## Global event bus for decoupled communication between systems (UI, audio, gameplay).
## Keep signals stable; prefer adding new ones over renaming to avoid breaking listeners.
class_name GameEvents
extends Node

# Match / Session
signal match_started()
signal match_ended(victory: bool)
signal paused_changed(paused: bool)

# Economy / Upgrades
signal gold_changed(new_gold: int, delta: int)
signal upgrade_purchased(upgrade_id: StringName)

# Request-style signals (system listens and validates)
signal spawn_unit_requested(unit_id: StringName, lane_id: int)

# Combat / Entities (notifications)
signal unit_spawned(unit: Node, unit_id: StringName, lane_id: int, team_id: int)
signal unit_died(unit: Node, unit_id: StringName, lane_id: int, team_id: int)

signal base_hp_changed(team_id: int, new_hp: int, delta: int)
signal damage_applied(attacker: Node, target: Node, amount: int)
