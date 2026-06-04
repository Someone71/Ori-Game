extends CharacterBody2D

@onready var bashArea = $Area2D

const SPEED = 400.0
const JUMP_VELOCITY = -800.0
var speedLimitY = 800
var negSpeedLimitY = -800
var speedLimitX = 800
var negSpeedLimitX = -800

var inAir = true

# Dash variables
var dashSpeed = 800.0
var dashTime = 0.175
var isDashing = false
var dashTimer = 0.0
var dashDir = Vector2.ZERO
var dashCD = 0.0

var wallBounceSpeedTimer = 0.35
var isWaveDashing = false

# Wall jump/bounce speed variable
var prevX = 0

# Coyote time amount
var coyoteTime = 0.1
var wallBounceCoyoteTime = 0.15

func dash():
	dashDir = Input.get_vector("left", "right", "up", "down")
	dashDir = dashDir.normalized()
	isDashing = true
	dashCD = 1
	dashTimer = dashTime
	velocity = dashDir * dashSpeed * 0.75	
	if Input.is_action_pressed("up"):
		velocity.y -= 200
		
func movement(delta):
	var direction := Input.get_axis("left", "right")
	if direction:
		if velocity.x < 500 and velocity.x > -500:
			velocity.x += direction * 1200 * delta
		
func jump():
	if Input.is_action_just_pressed("jump") and not isDashing and (is_on_floor() or coyoteTime > 0):
		velocity.y = JUMP_VELOCITY
		
func waveDash():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		var direction := Input.get_axis("left", "right")
		isWaveDashing = true
		velocity.x = direction * dashSpeed * 2
		velocity.y = -500
		
func wallJump():
	var dashOffVal: float
	if velocity.x == 0 and prevX != 0:
		dashOffVal = -prevX
	if dashOffVal <= 200 and dashOffVal >= -200:
		if Input.is_action_pressed("left"):
			dashOffVal = 400
		elif Input.is_action_pressed("right"):
			dashOffVal = -400
	if Input.is_action_just_pressed("jump") and is_on_wall_only():
		velocity.y -= dashSpeed * 0.6
		velocity.x = dashOffVal
		
func wallBounce():
	var dashOffVal: float
	wallBounceSpeedTimer = 0.35
	if velocity.x == 0 and prevX != 0:
		dashOffVal = -prevX
	if dashOffVal <= 200 and dashOffVal >= -200:
		if Input.is_action_pressed("left"):
			dashOffVal = 300
		elif Input.is_action_pressed("right"):
			dashOffVal = -300
	if Input.is_action_pressed("up") and Input.is_action_just_pressed("jump") and (is_on_wall_only() or wallBounceCoyoteTime > 0):
		negSpeedLimitY = -1050
		velocity.y -= dashSpeed * 0.75
		velocity.x = dashOffVal
		
func speedFallOff(delta):
	var deltaSpeedX = velocity.x
	if is_on_floor():
		velocity.x -= deltaSpeedX * 3 * delta
	elif velocity.x < 200 and velocity.x > -200 and is_on_floor():
		velocity.x -= deltaSpeedX * 5 * delta
	else:
		velocity.x -= deltaSpeedX / 1.05 * delta

func bash():
	if(Input.is_action_just_pressed("bash")):
		var projectile = get_closest_projectile()
		if projectile != null:
			print(projectile)
	
func get_closest_projectile():
	var closest = null
	var closestDistance = INF
	
	var spaceState = get_world_2d().direct_space_state
	for projectile in bashArea.get_overlapping_areas():
		var query = PhysicsRayQueryParameters2D.create(global_position, projectile.global_position)
		
		query.exclude = [self]
		query.collision_mask = 1 << 0
		var wall_hit = spaceState.intersect_ray(query)
		
		if wall_hit.is_empty():
			var distance = global_position.distance_squared_to(projectile.global_position)
			if distance < closestDistance:
				closestDistance = distance
				closest = projectile
	return closest
	
func _physics_process(delta: float) -> void:
	# Functionality of the speed limits in any direction
	if velocity.x > speedLimitX:
		velocity.x = speedLimitX
	if velocity.x < negSpeedLimitX:
		velocity.x = negSpeedLimitX
	if velocity.y > speedLimitY:
		velocity.y = speedLimitY
	if velocity.y < negSpeedLimitY:
		velocity.y = negSpeedLimitY
		
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity()*1.25 * delta*2
		coyoteTime -= delta
	
	if is_on_floor():
		coyoteTime = 0.1
	if is_on_wall_only():
		wallBounceCoyoteTime = 0.1
	if not is_on_wall_only():
		wallBounceCoyoteTime -= delta

	# Handle dash and the wallBounce timer
	dashCD -= delta
	wallBounceSpeedTimer -= delta
	if Input.is_action_just_pressed("dash") and not isDashing and dashCD <= 0:
		dash()
	
	# Allows for wavedashing and adjusts movement speed while dashing
	if isDashing:
		waveDash()
		wallBounce()
	if not isDashing:
		wallJump()
	if is_on_floor():
		dashCD = 0
	dashTimer -= delta
	if dashTimer <= 0:
		isDashing = false
	
	# Allows wallbounces to be higher than a typical wall jump
	if wallBounceSpeedTimer <= 0:
		negSpeedLimitY = -800
	if velocity.x != 0:
		prevX = velocity.x
		
	jump()
	movement(delta)
	speedFallOff(delta)
	move_and_slide()
	bash()
