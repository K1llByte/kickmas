extends Node2D

@onready var ground1_scene = preload("res://scenes/ground1.tscn")

func _process(delta: float):
	_update_score_label()

func _ready():
	_spawn_ground(0)
	
func _update_score_label():
	$Camera/GameOver.text = str(Global.player_score())

func _spawn_ground(x):
	var instance = ground1_scene.instantiate()
	instance.global_position = Vector2(x, 1000)
	self.add_child(instance)

#func _update_ground_spawner():
	#$Camera/Camera2D.global_position
	#var instance = ground1_scene.instantiate()
	#instance.global_position = Vector3(0, 2, 0)
	#add_child(instance)
