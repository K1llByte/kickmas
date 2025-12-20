extends Area2D

signal game_over

func _ready():
	self.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node):
	if body.is_in_group("ball"):
		Global.game_over()
