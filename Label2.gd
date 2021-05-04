extends Label

var start_position = Vector2()

func _ready():
	start_position = rect_position

func _physics_process(delta):
	rect_position = get_parent().get_parent().get_parent().position + start_position
	text = var2str(get_parent().get_node("Timer").get_time_left())
