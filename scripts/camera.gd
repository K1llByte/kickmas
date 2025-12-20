extends Node2D

# Speed in pixels per second
@export var camera_base_speed := 90.0  

# Initial grace period
var timer_accum := 0.0
var timer_interval := 1.0  # seconds

func _process(delta):
	if Global.is_playing:
		self.timer_accum += delta
		if self.timer_accum >= self.timer_interval:
			# Move camera left at constant speed
			position.x -= camera_base_speed * delta * Global.scrolling_speed_multiplier
