extends Label

var time_elapsed: float = 0.0
var game_over: bool = false

func _process(delta: float) -> void:
	if game_over:
		return
		
	time_elapsed += delta
	text = str(int(time_elapsed))

func on_game_over() -> void:
	game_over = true
