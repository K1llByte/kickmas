extends CharacterBody2D

@export var speed := 400.0

var ball_in_range: Node = null

func _ready():
	$KickArea.body_entered.connect(_on_ball_entered)
	$KickArea.body_exited.connect(_on_ball_exited)

func _physics_process(delta):
	var direction := 0
	var is_ball_falling := true

	if Input.is_action_pressed("plr_left"):
		direction -= 1
	if Input.is_action_pressed("plr_right"):
		direction += 1
	# Update player movement
	velocity.x = direction * speed
	velocity.y = 0
	
	if ball_in_range and Input.is_action_just_pressed("plr_kick") and ball_in_range.is_falling():
		_kick_ball()
		is_ball_falling = false

	move_and_slide()

	_clamp_to_viewport()

func _kick_ball():
	assert(ball_in_range, "Ball should be here")
	print("kicked ball!")
	ball_in_range.velocity.y = -ball_in_range.velocity.y

func _on_ball_entered(body: Node):
	ball_in_range = body

func _on_ball_exited(body: Node):
	ball_in_range = null

func _clamp_to_viewport():
	var viewport_rect = get_viewport_rect()
	var half_width = self.transform.origin.x

	position.x = clamp(
		position.x,
		half_width,
		viewport_rect.size.x - half_width
	)
