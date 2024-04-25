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
	
	var gravitational_parameter = GRAVITATIONAL_CONSTANT * local_planet.mass
	var specific_angular_momentum = direction.cross(velocity)
	var semilatus_rectum = pow(specific_angular_momentum, 2) / gravitational_parameter
	# TODO actually calculate this
	var orbital_eccentricity = 0
	
	queue_redraw()


func _draw():
	draw_rect(Rect2(-SIZE/2, -SIZE/2, SIZE, SIZE), Color.LIGHT_GREEN)
	draw_rect(Rect2(-1, -1, 2, 2), Color.RED)
	
	if (local_planet):
		draw_arc(
			local_planet.position - position, 
			position.distance_to(local_planet.position), 
			0, TAU, 128, Color.AQUA
		)
	
	
func set_local_planet(planet: Area2D):
	local_planet = planet
	# set the rocket's position
	position = local_planet.position - Vector2(0, local_planet.radius_px * 1.5)
	
	# give the rocket some horizontal motion to get it falling
	var direction = local_planet.position - position
	velocity = direction.normalized().orthogonal() * HORIZONTAL_VELOCITY
	

