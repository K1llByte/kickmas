extends CharacterBody2D

@export var speed := 400.0
@export var kick_force := 500.0
@export var kick_deviation := 100.0
@export var gravity := 1600.0
@export var max_fall_speed := 800.0
@export var jump_velocity := -800.0
var is_kicking = false
var is_jumping = false

var ball_in_range: Node = null

func _ready():
	$KickArea.body_entered.connect(_on_ball_entered)
	$KickArea.body_exited.connect(_on_ball_exited)

func _physics_process(delta):
	# Only apply gravity to player if he is not on the ground
	if not self.is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	var direction := 0
	
	if Global.is_playing:
		if self.is_on_floor() and is_jumping and $AnimatedSprite2D.animation != "end_jump":
			$AnimatedSprite2D.play("end_jump")
			$AnimatedSprite2D.animation_finished.connect(_on_jump_finished)
		
		##############################################
		# Move player
		##############################################
		# Player horizontal movement
		if Input.is_action_pressed("plr_left"):
			direction -= 1
			$AnimatedSprite2D.flip_h = false
		if Input.is_action_pressed("plr_right"):
			direction += 1
			$AnimatedSprite2D.flip_h = true
			
		# Update move animation
		if not is_kicking and not is_jumping:
			if direction == 0:
				$AnimatedSprite2D.play("idle")
			elif direction == 1 and self.is_on_floor():
				$AnimatedSprite2D.play("running")
			elif direction == -1 and self.is_on_floor():
				$AnimatedSprite2D.play("running")

		# Ball kicking
		if Input.is_action_just_pressed("plr_kick"):
			is_kicking = true
			$AnimatedSprite2D.play("kick")
			$AnimatedSprite2D.animation_finished.connect(_on_kick_finished)
			if ball_in_range and ball_in_range.is_falling():
				_kick_ball()

		# Player jumping
		if self.is_on_floor() and Input.is_action_just_pressed("plr_jump"):
			velocity.y = jump_velocity
			$AnimatedSprite2D.play("start_jump")
			is_jumping = true
		
	# Update player movement
	self.velocity.x = direction * (speed + (Global.scrolling_speed_multiplier - 1.0) * speed)
	# Update physics move
	move_and_slide()
	
	#_clamp_to_viewport()

func _move():
	var direction := 0
	
	# Player horizontal movement
	if Input.is_action_pressed("plr_left"):
		direction -= 1
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("plr_right"):
		direction += 1
		$AnimatedSprite2D.flip_h = true
		
	# Update move animation
	if not is_kicking and not is_jumping:
		if direction == 0:
			$AnimatedSprite2D.play("idle")
		elif direction == 1 and self.is_on_floor():
			$AnimatedSprite2D.play("running")
		elif direction == -1 and self.is_on_floor():
			$AnimatedSprite2D.play("running")
		
	# Update player movement
	self.velocity.x = direction * speed  * Global.scrolling_speed_multiplier

func _kick_ball():
	assert(ball_in_range, "Ball should be here")
	# Determine left or right
	var ball_pos = ball_in_range.global_position
	var kick_area_center = $KickArea.global_position
	
	var horizontal_dir := 0
	if ball_pos.x < kick_area_center.x:
		horizontal_dir = -1
	else:
		horizontal_dir = 1

	ball_in_range.linear_velocity = Vector2.ZERO
	ball_in_range.apply_impulse(Vector2(horizontal_dir * kick_deviation, -kick_force))

func _on_kick_finished():
	is_kicking = false
	$AnimatedSprite2D.animation_finished.disconnect(_on_kick_finished)
	
func _on_jump_finished():
	is_jumping = false
	$AnimatedSprite2D.animation_finished.disconnect(_on_jump_finished)

func _on_ball_entered(body: Node):
	if body.is_in_group("ball"):
		ball_in_range = body

func _on_ball_exited(body: Node):
	if body.is_in_group("ball"):
		ball_in_range = null

func _clamp_to_viewport():
	var viewport_rect = get_viewport_rect()
	var half_width = $CollisionShape2D.position.x

	position.x = clamp(
		position.x,
		half_width,
		viewport_rect.size.x - half_width
	)
