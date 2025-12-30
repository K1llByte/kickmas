extends Node2D

@export var spawn_buffer := 800.0 # how far offscreen to spawn
@export var kickable_ball_color := Color(0.42, 0.611, 0.0, 0.761)
@export var ball_in_range_color := Color(0.904, 0.108, 0.0, 0.761)

@onready var camera: Camera2D
@onready var ball_scene = preload("res://scenes/ball.tscn")
@onready var building1_scene = preload("res://scenes/buildings/building1.tscn")
@onready var building2_scene = preload("res://scenes/buildings/building2.tscn")
@onready var building3_scene = preload("res://scenes/buildings/building3.tscn")


var ground_types := []
var next_spawn_x := 0.0
var previous_ground_width := 0.0
var is_first_spawn := true
var has_started_game = false

func _process(delta: float):
	#if not is_instance_valid(camera):
		#return
	_update_score_label()
	_update_ground_spawner()
	_cleanup_old_ground()
	_update_ball_outline()

func _input(event):
	if not has_started_game and event is InputEventKey and event.pressed:
		print("pressed any key")
		Global.is_playing = true
		has_started_game = true
		var ball = ball_scene.instantiate()
		ball.transform.origin = Vector2(800.0, 195.0)
		add_child(ball)

func _ready():
	camera = $Camera/Camera2D
	ground_types = [
		{ "scene": building1_scene, "width": 1260.0 }, # This building should be the last
		{ "scene": building2_scene, "width": 924.0 },
		{ "scene": building3_scene, "width": 807.0 } 
	]

	# Start spawning to the left
	next_spawn_x = camera.global_position.x - 170.0
	previous_ground_width = 0.0

	# Pre-fill
	_spawn_next_ground(ground_types[randi_range(1, ground_types.size() - 1)])
	for i in range(2):
		_spawn_next_ground(ground_types.pick_random())
	
func _spawn_next_ground(ground_data):
	var width = ground_data.width

	# Advance spawn point using half-widths
	if previous_ground_width > 0.0:
		next_spawn_x -= (previous_ground_width * 0.5 + width * 0.5)
	
	var instance = ground_data.scene.instantiate()
	instance.global_position = Vector2(
		next_spawn_x,
		560 + randf_range(0, 200)
	)

	$Grounds.add_child(instance)

	# Store for next spawn
	previous_ground_width = width

func _update_ground_spawner():
	if camera.global_position.x - spawn_buffer <= next_spawn_x:
		_spawn_next_ground(ground_types.pick_random())

func _cleanup_old_ground():
	for child in $Grounds.get_children():
		if child.global_position.x > camera.global_position.x + 6200:
			child.queue_free()

func _update_score_label():
	$Camera/ScoreLabel.text = str(Global.player_score())

func _update_ball_outline():
	if $Ball != null:
		# Change ball color acording to distance to player
		if $Player.ball_in_range != null:
			if $Ball.linear_velocity.y > 0:
				$Ball.set_outline_color(kickable_ball_color)
			else:
				$Ball.set_outline_color(ball_in_range_color)
		else:
			# Invisible outline
			$Ball.set_outline_color(Color(0.0, 0.0, 0.0, 0.0))
