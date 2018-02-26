extends MeshInstance

# A simple program to rotate the model around

var model = null
const SPEED = 40

func _ready():
	set_process(true)


func _process(delta):
	rotation_degrees.y += delta * SPEED