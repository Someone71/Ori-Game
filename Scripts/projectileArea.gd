extends Area2D

@export var speed : int = 200
var direction : Vector2

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta
