extends Node2D

@onready var game_scene = preload("res://scenes/game.tscn")
@onready var leaderboard_scene = preload("res://scenes/leaderboard.tscn")

func _ready():
	$MainMenu/HBoxContainer/PlayButton.pressed.connect(_on_play)
	Global.on_game_over.connect(_on_game_over)

func _process(delta):
	if not Global.is_playing and Input.is_action_pressed("menu_start"):
			_on_play()

func _on_play():
	print("Playing")
	$MainMenu.hide()
	# TODO: Do fadeout animation
	var game_instance = game_scene.instantiate()
	add_child(game_scene.instantiate())
	Global.play()

func _on_game_over():
	$CanvasLayer.add_child(leaderboard_scene.instantiate())
