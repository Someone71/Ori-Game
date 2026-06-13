extends Node2D

@onready var main = get_tree().get_root().get_node("OriGame")
@onready var projectile = load("res://Scenes/MapProjectile.tscn")

@export var projectileSpeed = 200
@export var projectileMass = 1
@export var shootingCD = 3

var shootingTimer = shootingCD

func _physics_process(delta: float) -> void:
	shootingTimer -= delta
	if shootingTimer <= 0:
		shootingTimer = shootingCD
		shoot()

func shoot():
	var instance = projectile.instantiate()
	instance.velocity = Vector2.from_angle(rotation) * projectileSpeed
	instance.position = global_position
	instance.mass = projectileMass
	main.add_child.call_deferred(instance)
