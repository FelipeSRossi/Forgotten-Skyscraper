extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var camera
var oldposition = Vector2() 
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	camera = get_parent().get_parent().get_node("player").get_node("Camera2D")
	oldposition.x = camera.global_position.x
	oldposition.y = camera.global_position.y
	set_physics_process(true)
	

func _physics_process(delta):
	#translate( Vector3(0.0075*(camera.global_position.x - oldposition.x), 0.015*(-camera.global_position.y + oldposition.y),0))
	translate( Vector3(0.00015*(camera.global_position.x - oldposition.x), 0, 0))
	rotate_y( 0.00035*(camera.global_position.x -oldposition.x))
	#rotate_x( -0.015*(player.position.y -oldposition.y))
	oldposition.x = camera.global_position.x
	oldposition.y = camera.global_position.y
