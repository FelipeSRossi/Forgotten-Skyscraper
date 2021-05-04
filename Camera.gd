extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var camera
var oldposition = Vector2() 
var newposition = Vector2() 
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	camera = get_parent().get_parent().get_parent().get_node("World/player/Camera2D")
	oldposition = camera.get_camera_position()
	set_physics_process(true)
	

func _physics_process(delta):
	#translate( Vector3(0.0075*(camera.global_position.x - oldposition.x), 0.015*(-camera.global_position.y + oldposition.y),0))
	newposition =  camera.get_camera_position()
	translate( Vector3(0.0025*(newposition.x - oldposition.x),-(0.005*(newposition.y - oldposition.y)), 0))
	rotate_y( 0.00015*(newposition.x -oldposition.x))
	#rotate_x( -0.00015*(newposition.y -oldposition.y))
	oldposition.x = newposition.x
	oldposition.y = newposition.y
