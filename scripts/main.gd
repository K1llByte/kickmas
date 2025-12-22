extends Node2D

@onready var game_scene = preload("res://scenes/game.tscn")
@onready var leaderboard_scene = preload("res://scenes/leaderboard/leaderboard_online.tscn")
@onready var gameover_scene = preload("res://scenes/gameover_popup.tscn")

func _ready():
	$MainMenu/HBoxContainer/PlayButton.pressed.connect(_on_play)
	$MainMenu/HBoxContainer/MuteButton.pressed.connect(_on_mute_audio)
	Global.on_game_over.connect(_on_game_over)

#func _process(delta):
	#if not Global.is_playing and Input.is_action_pressed("menu_start"):
			#_on_play()

func _on_play():
	var game_root = get_node("Root")
	if game_root != null:
		game_root.queue_free()
		await get_tree().process_frame
	print("Playing")
	$MainMenu.hide()
	# TODO: Do fadeout animation
	var game_instance = game_scene.instantiate()
	add_child(game_scene.instantiate())
	Global.play()
	$MainMenu/MainMusicPlayer.stop()


var master_bus := AudioServer.get_bus_index("Master")
func _on_mute_audio():
	var muted = AudioServer.is_bus_mute(master_bus)
	AudioServer.set_bus_mute(master_bus, !muted)


func _on_game_over():
	$CanvasLayer.add_child(leaderboard_scene.instantiate())
	var gameover = gameover_scene.instantiate()
	gameover.get_node("HomeButton").pressed.connect(_on_home)
	gameover.get_node("RetryButton").pressed.connect(_on_retry)
	gameover.get_node("ScoreLabel").text = str(Global.player_score())
	if Global.player_high_score < Global.player_score():
		gameover.get_node("NewHighscore").show()
	$CanvasLayer.add_child(gameover)

func _on_retry():
	# Remove game scene
	for child in get_node("CanvasLayer").get_children():
		child.queue_free()
	await get_tree().process_frame
	# Play game
	_on_play()

func _on_home():
	# Remove game scene
	get_node("Root").queue_free()
	# Remove leaderboard and gameover scene
	for child in get_node("CanvasLayer").get_children():
		child.queue_free()
	await get_tree().process_frame
	# Show MainMenu
	$MainMenu.show()
	$MainMenu/MainMusicPlayer.play()
