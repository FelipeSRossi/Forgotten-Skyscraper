extends Label

var start_position = Vector2()

func _ready():
	start_position = rect_position

func _physics_process(delta):
	rect_position = $"../Sprite".position + start_position

func _on_SecurityTrooper_state_changed(states_stack):
	text = states_stack[0].get_name()
