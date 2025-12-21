extends Node

var player_raw_score := 0.0
var scrolling_speed_multiplier := 1.2
var is_playing = false
signal on_game_over

func _process(delta):
	if is_playing:
		self.player_raw_score += delta
		scrolling_speed_multiplier += delta * 0.1

func game_over():
	if is_playing:
		print("Game Over")
		is_playing = false
		on_game_over.emit()

func play():
	self.player_raw_score = 0.0
	is_playing = true

func _ready():
	game_over()
	play()

func player_score() -> int:
	return int(player_raw_score * 2.0)
