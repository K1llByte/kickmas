extends CharacterBody2D

@export var gravity := 200.0
@export var max_fall_speed := 300.0

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)

	move_and_slide()

	#_clamp_to_viewport()

func is_falling() -> bool:
	return self.velocity.y > 0

#func _clamp_to_viewport():
	#var viewport_rect = get_viewport_rect()
	#var radius = $CollisionShape2D.shape.extents.x
#
	#position.y = clamp(
		#position.y,
		#radius,
		#viewport_rect.size.y - radius
	#)
