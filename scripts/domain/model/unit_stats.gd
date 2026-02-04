class_name UnitStats
extends Resource

var max_hp: int
var attack_damage: int
var move_speed: float
var attack_cooldown: float
var armor: int

func apply_modifier(m: StatModifier) -> void:
	match m.stat:
		StatId.UnitStat.MAX_HP:
			max_hp = int(round((max_hp + m.add) * m.mul))
		StatId.UnitStat.ATTACK_DAMAGE:
			attack_damage = int(round((attack_damage + m.add) * m.mul))
		StatId.UnitStat.MOVE_SPEED:
			move_speed = (move_speed + m.add) * m.mul
		StatId.UnitStat.ATTACK_SPEED:
			attack_cooldown = (attack_cooldown + m.add) * m.mul
		StatId.UnitStat.ARMOR:
			armor = int(round((armor + m.add) * m.mul))
