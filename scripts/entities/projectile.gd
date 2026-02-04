class_name ProjectileEntity
extends Area2D

@export var speed: float = 600.0
@export var max_lifetime: float = 3.0

var team_id: int
var damage: int
var dir: Vector2 = Vector2.RIGHT

func init(t: int, dmg: int, direction: Vector2) -> void:
	team_id = t
	damage = dmg
	dir = direction.normalized()

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

	if max_lifetime > 0.0:
		var timer := Timer.new()
		timer.one_shot = true
		timer.wait_time = max_lifetime
		timer.timeout.connect(queue_free)
		add_child(timer)
		timer.start()

func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta

func _try_damage(target: Node) -> bool:
	var h := target.gqet_node_or_null("Health") as Health
	if h == null:
		return false
	h.apply_damage(damage)
	Events.damage_applied.emit(self, target, damage)
	return true

func _on_area_entered(a: Area2D) -> void:
	if _try_damage(a.get_parent()):
		queue_free()

func _on_body_entered(b: Node) -> void:
	if _try_damage(b):
		queue_free()
