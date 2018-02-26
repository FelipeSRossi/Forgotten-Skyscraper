extends Camera

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player
var oldposition = Vector2() 
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	player = get_parent().get_parent().get_node("player")
	oldposition.x = player.position.x
	oldposition.y = player.position.y
	set_physics_process(true)
	

func _physics_process(delta):
	translate( Vector3(0.015*(player.position.x - oldposition.x), 0.015*(player.position.y - oldposition.y),0))
	oldposition.x = player.position.x
	oldposition.y = player.position.y
