extends Area2D


const SIZE = 8
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
		
	var direction_to_planet = local_planet.position - position
	acceleration = direction_to_planet.normalized() * GRAVITATIONAL_CONSTANT * (local_planet.mass / direction_to_planet.length_squared())
	velocity += acceleration * delta
	position += velocity * delta
	
	if Input.is_action_pressed("accelerate"):
		velocity += velocity.normalized() * delta * 10
	elif Input.is_action_pressed("decelerate"):
		velocity -= velocity.normalized() * delta * 10
	
	queue_redraw()
	
	
func draw_orbit():
	if (local_planet):
		# calculate the orbit in polar coordinates
		var direction_from_planet = position - local_planet.position
		var gravitational_parameter = GRAVITATIONAL_CONSTANT * local_planet.mass
		var specific_angular_momentum = direction_from_planet.cross(velocity)
		var semilatus_rectum = pow(specific_angular_momentum, 2) / gravitational_parameter
		var eccentricity_vector = (pow(velocity.length(), 2) / gravitational_parameter - 1 / direction_from_planet.length()) * direction_from_planet
		eccentricity_vector = eccentricity_vector - (direction_from_planet.dot(velocity) / gravitational_parameter) * velocity
		var orbital_eccentricity = eccentricity_vector.length()
		
		# rotate the orbit
		var distance_to_planet = position.distance_to(local_planet.position)
		var expected_angle = acos((semilatus_rectum / distance_to_planet - 1) / orbital_eccentricity)
		# expected angle could be one of two values
		# the choice depends on acceleration and direction
		if (
			# accelerating AND going clockwise
			(velocity.dot(acceleration) > 0 and direction_from_planet.angle_to(velocity) < 0) or 
			# decelerating AND going anti-clockwise
			(velocity.dot(acceleration) < 0 and direction_from_planet.angle_to(velocity) > 0)
		):
			expected_angle = abs(expected_angle)
		else:
			expected_angle = -abs(expected_angle)
		var actual_angle = direction_from_planet.angle()
		var angle_diff = expected_angle - actual_angle
		
		# actually draw the orbit
		var num_points = 128
		var points = PackedVector2Array()
		for n in num_points:
			var theta = (float(n) / num_points) * TAU
			var r = semilatus_rectum / (1 + orbital_eccentricity * cos(theta))
			points.append(r * Vector2.from_angle(theta - angle_diff) - direction_from_planet)
		# close the loop
		points.append(points[0])
		draw_polyline(points, Color.AQUA, 0.5, true)
		
		
func draw_rocket():
	var angle = velocity.angle()
	var points = PackedVector2Array()
	points.append(Vector2(-SIZE, -SIZE / 2.0).rotated(angle))
	points.append(Vector2(-SIZE, SIZE / 2.0).rotated(angle))
	points.append(Vector2(SIZE, SIZE / 2.0).rotated(angle))
	points.append(Vector2(SIZE, -SIZE / 2.0).rotated(angle))
	draw_colored_polygon(points, Color.LIGHT_GREEN)
	
	draw_line(Vector2.ZERO, velocity, Color.RED)
	draw_line(Vector2.ZERO, acceleration, Color.PURPLE)


func _draw():	
	draw_orbit()	
	draw_rocket()	
	
	
func set_local_planet(planet: Area2D):
	local_planet = planet
	# set the rocket's position
	position = local_planet.position + Vector2(local_planet.radius_px * 1.5, 0)
	
	# give the rocket some velocity to get it falling
	var direction_from_planet = position - local_planet.position
	# speed to achieve a circular orbit
	var speed = sqrt((GRAVITATIONAL_CONSTANT * local_planet.mass) / direction_from_planet.length())
	velocity = direction_from_planet.normalized().orthogonal() * speed
	

