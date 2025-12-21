extends Node2D

@export var spawn_buffer := 800.0 # how far offscreen to spawn

@onready var camera := get_viewport().get_camera_2d()
@onready var ground1_scene = preload("res://scenes/ground1.tscn")
@onready var building1_scene = preload("res://scenes/buildings/building1.tscn")
@onready var building2_scene = preload("res://scenes/buildings/building2.tscn")
@onready var building3_scene = preload("res://scenes/buildings/building3.tscn")

var ground_types := []
var next_spawn_x := 0.0
var previous_ground_width := 0.0
var is_first_spawn := true

func _process(delta: float):
	_update_score_label()
	_update_ground_spawner()
	_cleanup_old_ground()

func _ready():
	ground_types = [
		{ "scene": building1_scene, "width": 1260.0 }, # this building should be the last
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

	add_child(instance)

	# Store for next spawn
	previous_ground_width = width

func _update_ground_spawner():
	if camera.global_position.x - spawn_buffer <= next_spawn_x:
		_spawn_next_ground(ground_types.pick_random())

func _cleanup_old_ground():
	for child in get_children():
		if child.global_position.x > camera.global_position.x + 6200:
			child.queue_free()

func _update_score_label():
	$Camera/ScoreLabel.text = str(Global.player_score())
