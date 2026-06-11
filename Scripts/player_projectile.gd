extends Area2D

@export var speed : int = 500
@export var mass = 1.0
var velocity: Vector2 = Vector2.ZERO

func setup(dir: Vector2) -> void:
	velocity = dir * speed
	rotation = dir.angle()

func _physics_process(delta: float) -> void:
	velocity.y += 0.5*gravity * mass * delta
	position += velocity * delta
