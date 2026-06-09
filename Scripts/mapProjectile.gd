extends Area2D

@export var speed : int = 200
@export var mass = 1
var direction : Vector2

var startingPosition : Vector2

func _ready() -> void:
	position = startingPosition

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta
