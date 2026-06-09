extends Node2D

@onready var main = get_tree().get_root().get_node("OriGame")
@onready var projectile = load("res://Scenes/MapProjectile.tscn")

@export var projectileSpeed = 200
@export var projectileMass = 1.0

var shootingCD = 3

func _physics_process(delta: float) -> void:
	shootingCD -= delta
	if shootingCD <= 0:
		shootingCD = 3
		shoot()

func shoot():
	var instance = projectile.instantiate()
	instance.rotation = rotation
	instance.position = global_position
	instance.speed = projectileSpeed
	instance.mass = projectileMass
	main.add_child.call_deferred(instance)
