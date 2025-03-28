extends Camera2D

@export var TIME_SCALE: float = 0.5
@export var RADIUS: float = 10

var time = 0

func _process(delta):
	time += delta * TIME_SCALE
	position.x = sin(time) * RADIUS
	position.y = cos(time) * RADIUS
