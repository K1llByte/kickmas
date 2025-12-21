extends Node

const DEFAULT_SCROLL_SPEED_MULT := 1.2
var player_raw_score := 0.0
var player_high_score := 0
var scrolling_speed_multiplier := DEFAULT_SCROLL_SPEED_MULT
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
		player_high_score = player_score()

func play():
	self.player_raw_score = 0.0
	self.scrolling_speed_multiplier = DEFAULT_SCROLL_SPEED_MULT
	is_playing = true

func _ready():
	game_over()
	play()
	_init_leaderboard()

func player_score() -> int:
	return int(player_raw_score * 2.0)

func _init_leaderboard():
	SilentWolf.configure({
		"api_key": "fyvestFMjaTsiYdJhRWv3rjfKbcKZLD2adiSFZXb",
		"game_id": "SpaceJamProject",
		"game_version": "1.0",
		"log_level": 1
	})
