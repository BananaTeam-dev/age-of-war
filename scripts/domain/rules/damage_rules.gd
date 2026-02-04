class_name DamageRules
extends RefCounted

static func compute_basic_damage(
	attack_damage: int,
	armor: int,
	global_mul: float = 1.0
) -> int:
	var reduced := maxi(0, attack_damage - armor)
	return int(round(reduced * global_mul))

static func should_crit(rng: RandomNumberGenerator, crit_chance: float) -> bool:
	return rng.randf() < crit_chance
