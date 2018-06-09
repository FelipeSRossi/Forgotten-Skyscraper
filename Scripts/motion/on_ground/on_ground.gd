extends '../motion.gd'

var speed = 0.0
var velocity = Vector2()

func handle_input(host, event):
	if event.is_action_pressed('jump'):
		return 'jump'
	return .handle_input(host, event)

func update(host,delta):
		if(!host.is_on_floor()):
			return 'fall'