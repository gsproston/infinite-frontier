extends Area2D


const SIZE = 16
const HORIZONTAL_VELOCITY = 70
# a few standard orders out, but helps for simplicity
const GRAVITATIONAL_CONSTANT = 6.674

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var local_planet: Area2D = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (local_planet == null):
		return
		
	var direction = local_planet.position - position
	acceleration = direction.normalized() * GRAVITATIONAL_CONSTANT * (local_planet.mass / direction.length_squared())
	velocity += acceleration * delta
	position += velocity * delta


func _draw():
	draw_rect(Rect2(-SIZE/2, -SIZE/2, SIZE, SIZE), Color.LIGHT_GREEN)
	draw_rect(Rect2(-1, -1, 2, 2), Color.RED)
	
	
func set_local_planet(planet: Area2D):
	local_planet = planet
	# set the rocket's position
	position = local_planet.position - Vector2(0, local_planet.radius_px * 1.5)
	
	# give the rocket some horizontal motion to get it falling
	var direction = local_planet.position - position
	velocity = direction.normalized().orthogonal() * HORIZONTAL_VELOCITY
	

