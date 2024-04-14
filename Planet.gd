extends Area2D

@export var radius_px = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = radius_px


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_circle(Vector2(0,0), radius_px, Color.CORAL)
