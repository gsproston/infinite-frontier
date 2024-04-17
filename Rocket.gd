extends Area2D


const SIZE = 16
const ACCELERATION = 1
const HORIZONTAL_VELOCITY = 1

var velocity = Vector2.ZERO
var local_planet: Area2D = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (local_planet == null):
		return
		
	var direction = position - local_planet.position
	position += velocity * delta * direction.normalized()
	position += direction.normalized().orthogonal() * HORIZONTAL_VELOCITY
	velocity += ACCELERATION * delta * direction.normalized()


func _draw():
	draw_rect(Rect2(-SIZE/2, -SIZE/2, SIZE, SIZE), Color.LIGHT_GREEN)
	draw_rect(Rect2(-1, -1, 2, 2), Color.RED)

