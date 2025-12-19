extends CharacterBody2D

@export var speed := 400.0

func _physics_process(delta):
	var direction := 0

	if Input.is_action_pressed("ui_left"):
		direction -= 1
	if Input.is_action_pressed("ui_right"):
		direction += 1

	velocity.x = direction * speed
	velocity.y = 0

	move_and_slide()

	_clamp_to_viewport()


func _clamp_to_viewport():
	var viewport_rect = get_viewport_rect()
	var half_width = $CollisionShape2D.shape.extents.x

	position.x = clamp(
		position.x,
		half_width,
		viewport_rect.size.x - half_width
	)
