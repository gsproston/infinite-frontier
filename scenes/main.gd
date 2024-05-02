extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# Start the rocket above the planet
	$Rocket.set_local_planet($Planet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rocket_area_entered(area):
	# Reset the rocket if it crashes
	$Rocket.set_local_planet($Planet)
