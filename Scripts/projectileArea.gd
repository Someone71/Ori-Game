extends Area2D

@export var speed : int = 200
@export var mass = 1.0
var direction : Vector2

func _physics_process(delta: float) -> void:
	#pass
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta
