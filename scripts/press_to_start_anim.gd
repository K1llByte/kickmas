extends Label

@export var amplitude := 10.0   # pixels up/down
@export var speed := 0.3        # oscillations per second

var time := 0.0
var start_y := 0.0

func _ready():
	start_y = position.y

func _process(delta):
	time += delta
	position.y = start_y + sin(time * TAU * speed) * amplitude
