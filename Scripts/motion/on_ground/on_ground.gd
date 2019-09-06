extends '../motion.gd'

var speed = 0.0
var velocity = Vector2()
var damage = false
func handle_input(host, event):
	if event.is_action_pressed('jump'):
		return 'jump'
	if event.is_action_pressed('slide'):
		return 'slide'
	return .handle_input(host, event)
	
