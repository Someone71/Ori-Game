extends Node2D

@onready var main = get_tree().get_root().get_node("OriGame")
@onready var projectile = load("res://Scenes/MapProjectile.tscn")

var shootingCD = 3

func _physics_process(delta: float) -> void:
	shootingCD -= delta
	if shootingCD <= 0:
		shootingCD = 3
		shoot()

func shoot():
	var instance = projectile.instantiate()
	instance.rotation = rotation
	instance.startingPosition = global_position
	get_tree().current_scene.add_child(instance)
