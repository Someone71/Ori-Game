extends Area2D

@export var speed : int = 200
@export var mass = 1
var velocity: Vector2 = Vector2.ZERO

func setup(dir: Vector2) -> void:
	velocity = dir * speed + 10*Vector2.DOWN
	rotation = dir.angle()

func _physics_process(delta: float) -> void:
	position += velocity * delta
