extends Area2D


const SIZE = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_rect(Rect2(-SIZE/2, -SIZE/2, SIZE, SIZE), Color.LIGHT_GREEN)

