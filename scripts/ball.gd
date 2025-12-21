extends RigidBody2D

func is_falling() -> bool:
	return self.linear_velocity.y > 0

func _ready():
	self.apply_impulse(Vector2(-60,-400.0))

func set_outline_color(color: Color):
	$AnimatedSprite2D.material.set_shader_parameter("outline_color", color)
