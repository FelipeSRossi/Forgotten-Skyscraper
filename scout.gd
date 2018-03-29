extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
var moving_left = false
var moving_right = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if(position.x < get_node("PatrolMax").position.x and !moving_right):
		moving_left = true
		print("here")
		if(position.x ==  get_node("PatrolMax").position.x):
			moving_left = false
		move_and_slide(Vector2(1,0))
	elif(position.x > get_node("PatrolMin").position.x and !moving_left):
		moving_right = true
		print("there")
		if(position.x ==  get_node("PatrolMax").position.x):
			moving_left = false
		move_and_slide(Vector2(-1,0))
