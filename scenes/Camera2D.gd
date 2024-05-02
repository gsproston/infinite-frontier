extends Camera2D


const MIN_ZOOM = 0.5
const MAX_ZOOM = 2.0
const ZOOM_FACTOR = 1
const WHEEL_FACTOR = 4

# the target zoom level
var zoom_level = 1.0
var focus: Node2D = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (focus):
		position = focus.position
	
	if Input.is_action_pressed("zoom_in"):
		set_zoom_level(zoom_level + ZOOM_FACTOR * delta)
	elif Input.is_action_pressed("zoom_out"):
		set_zoom_level(zoom_level - ZOOM_FACTOR * delta)
	elif Input.is_action_just_pressed("zoom_in"):
		set_zoom_level(zoom_level + ZOOM_FACTOR * WHEEL_FACTOR * delta)
	elif Input.is_action_just_pressed("zoom_out"):
		set_zoom_level(zoom_level - ZOOM_FACTOR * WHEEL_FACTOR * delta)
		
		
func set_focus(new_focus: Node2D):
	focus = new_focus


func set_zoom_level(value: float) -> void:
	# limit the value between `min_zoom` and `max_zoom`
	zoom_level = clamp(value, MIN_ZOOM, MAX_ZOOM)
	zoom = Vector2(zoom_level, zoom_level)
