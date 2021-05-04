extends Node2D

var increase = false
var speed = 2  # rotation speed (in radians)
var radius = 30  # desired orbit radius
var approach = true
var oldpatrol
func _ready():
	pass

func _process(delta):
	
	if(!increase and radius >= 70):
		increase = true
	elif(radius <= 25):
		increase = false
		
	if(increase):
		radius = radius -rand_range(0.1,1);
	else:
		radius = radius +rand_range(0.1,1);
		
		
	if!(get_node("control").patrol):
		get_node("Sprite2").scale.x = 1
		get_node("control").position = Vector2(radius, 0)
		get_node("Sprite2").position = Vector2(radius, 0)
		
		position = get_parent().get_parent().get_node("player").position
		rotation += speed * delta
		get_node("control").rotation =  - rotation
		if(rotation <=-1):
			rotation = 0
	elif(get_node("control").patrol and !oldpatrol):
		pass
	else:
		get_node("Sprite2").position = get_node("control").position
		get_node("Sprite2").scale.x = get_node("control/Sprite").scale.x
		
	oldpatrol = get_node("control").patrol
