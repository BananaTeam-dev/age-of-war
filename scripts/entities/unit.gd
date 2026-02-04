class_name UnitEntity
extends CharacterBody2D

@export var team_id: int = 0
@export var lane_id: int = 0

@onready var health: Health = $Health
@onready var spawn_point: Marker2D = $ProjectileSpawnPoint

var def: UnitDef
var stats: UnitStats

var _attack_timer := 0.0
var _target: Node = null

func init_from_def(unit_def: UnitDef, computed_stats: UnitStats, t: int, lane: int) -> void:
	def = unit_def
	stats = computed_stats
	team_id = t
	lane_id = lane
	health.set_max_hp(stats.max_hp, true)

func _physics_process(delta: float) -> void:
	_attack_timer = maxf(0.0, _attack_timer - delta)

	velocity = Vector2(stats.move_speed * (team_id == 0 if 1.0 else -1.0), 0.0)
	move_and_slide()

	if _target != null and _attack_timer <= 0.0:
		_attack_timer = stats.attack_cooldown
		_do_attack(_target)

func _do_attack(target: Node) -> void:
	if def.projectile_scene != null:
		_spawn_projectile(target.global_position)
	else:
		_apply_melee_damage(target)

func _spawn_projectile(target_pos: Vector2) -> void:
	var p := def.projectile_scene.instantiate() as ProjectileEntity
	if p == null:
		return
	p.global_position = spawn_point.global_position
	p.init(team_id, stats.attack_damage, (target_pos - p.global_position).normalized())

	get_tree().current_scene.add_child(p)

func _apply_melee_damage(target: Node) -> void:
	var h := target.get_node_or_null("Health") as Health
	if h:
		h.apply_damage(stats.attack_damage)
