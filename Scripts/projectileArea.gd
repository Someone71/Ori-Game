extends Area2D

@export var speed : int = 400
@export var launch_speed : int = 300
@export var radius: float = 200.0
@export var force:float = -600.0
var direction : Vector2 = Vector2.ZERO
var is_close: bool = false
var player:CharacterBody2D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player");
	direction = Vector2.RIGHT.rotated(rotation)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player <= radius:
			is_close = true
			
	if is_close and player:
		var target_direction = (player.global_position-global_position).normalized()
		direction = direction.lerp(target_direction, 6.0*delta)
		position +=direction*speed*delta
	else:
		global_position += direction*launch_speed*delta
func _on_body_entered(body:Node2D)->void:
	if body.is_in_group("player"):
		if body.has_method("projectile_bounce"):
			body.projectile_bounce(force)
		queue_free()
