extends CharacterBody2D

var mass : float

func _ready() -> void:
	scale *= mass
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	rotation = velocity.angle()
	
	if collision and not get_parent().get_node("Player").isBashing:
		queue_free()
