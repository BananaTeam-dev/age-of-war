extends CharacterBody2D

@export var speed := 250.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# remember last horizontal direction
var facing_x := -1.0

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * speed
	move_and_slide()

	if dir.x != 0.0:
		facing_x = signf(dir.x)
	anim.flip_h = (facing_x > 0.0)

	if dir != Vector2.ZERO:
		if anim.animation != "running":
			anim.play("running")
	else:
		if anim.animation != "idle":
			anim.play("idle")
