extends Area2D

var speed : int
var mass : float
var direction : Vector2

func _ready() -> void:
	scale *= mass
	
func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta
