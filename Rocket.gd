extends Area2D


const SIZE = 8
const HORIZONTAL_VELOCITY = 80
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
	
	if Input.is_action_pressed("accelerate"):
		velocity += velocity.normalized() * delta * 10
	elif Input.is_action_pressed("decelerate"):
		velocity -= velocity.normalized() * delta * 10
	
	queue_redraw()
	
	
func draw_orbit():
	if (local_planet):
		var direction = local_planet.position - position
		var gravitational_parameter = GRAVITATIONAL_CONSTANT * local_planet.mass
		var specific_angular_momentum = direction.cross(velocity)
		var semilatus_rectum = pow(specific_angular_momentum, 2) / gravitational_parameter
		
		var eccentricity_vector = (pow(velocity.length(), 2) / gravitational_parameter - 1 / direction.length()) * direction
		eccentricity_vector = eccentricity_vector - (direction.dot(velocity) / gravitational_parameter) * velocity
		var orbital_eccentricity = eccentricity_vector.length()
		
		var num_points = 128
		var points = PackedVector2Array()
		
		for n in num_points:
			var theta = (float(n) / num_points) * TAU
			var r = semilatus_rectum / (1 + orbital_eccentricity * cos(theta))
			points.append(r * Vector2.from_angle(theta) + direction)
		# close the loop
		points.append(points[0])
	
		draw_polyline(points, Color.AQUA, 0.5, true)
		
		
func draw_rocket():
	var angle = velocity.angle() + PI / 2.0
	var points = PackedVector2Array()
	points.append(Vector2(SIZE / 2.0, SIZE).rotated(angle))
	points.append(Vector2(SIZE / 2.0, -SIZE).rotated(angle))
	points.append(Vector2(-SIZE / 2.0, -SIZE).rotated(angle))
	points.append(Vector2(-SIZE / 2.0, SIZE).rotated(angle))
	draw_colored_polygon(points, Color.LIGHT_GREEN)
	
	draw_line(Vector2.ZERO, velocity, Color.RED)
	draw_line(Vector2.ZERO, acceleration, Color.PURPLE)


func _draw():	
	draw_orbit()	
	draw_rocket()	
	
	
func set_local_planet(planet: Area2D):
	local_planet = planet
	# set the rocket's position
	position = local_planet.position - Vector2(local_planet.radius_px * -1.5, 0)
	
	# give the rocket some horizontal motion to get it falling
	var direction = local_planet.position - position
	velocity = direction.normalized().orthogonal() * HORIZONTAL_VELOCITY
	

