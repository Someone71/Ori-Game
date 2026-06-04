extends Camera2D
@onready var player = %Player

#size of the map in pixels
const mapX = 2304
const mapY = -1296

#min and max values for the camera position
var xMin = 576 / zoom.x
var xMax = mapX - 576 / zoom.x
var yMin = -324 / zoom.y
var yMax = mapY + 324 / zoom.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = 576
	position.y = -324

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#makes the camera follow the player
	#position.x += (player.position.x - position.x) / 100 + player.velocity.x / 200
	#position.y += (player.position.y - position.y) / 75 + player.velocity.y / 200
	position.x = move_toward(position.x, player.position.x, delta * 500)
	position.y = move_toward(position.y, player.position.y, delta * 500)
	
	#makes sure the camera stays within the bounds of the map
	if(position.x > xMax):
		position.x = xMax
	if(position.x < xMin):
		position.x = xMin
	if(position.y > yMin):
		position.y = yMin
	if(position.y < yMax):
		position.y = yMax
