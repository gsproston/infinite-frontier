extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# start the rocket above the planet
	reset_rocket()
	# start the camera on the planet
	$Camera2D.set_focus($Planet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rocket_area_entered(area):
	# reset the rocket if it crashes
	reset_rocket()



func reset_rocket():
	$Rocket.set_local_planet($Planet)


func _on_rocket_input_event(_viewport, event: InputEvent, _shape_idx):
	if (event.is_action("left_click")):
		$Camera2D.set_focus($Rocket)


func _on_planet_input_event(_viewport, event: InputEvent, _shape_idx):
	if (event.is_action("left_click")):
		$Camera2D.set_focus($Planet)
