extends 'on_ground.gd'

func enter(host):
	speed = 0.0
	velocity = Vector2()
	
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	if(host.get_node('AnimationPlayer').current_animation == 'Jump-landing'):
		host.get_node('AnimationPlayer').queue('Idle')
	else:
		host.get_node('AnimationPlayer').play('Idle')
	

func handle_input(host, event):
	var input_direction = get_input_direction()
	if input_direction:
		return "move"
	if event.is_action_pressed('melee'):
		return 'slash'
	elif event.is_action_pressed('parry'):
		return 'parry'
		
	return .handle_input(host, event)

func update(host, delta):
	var input_direction = get_input_direction()
	if input_direction:
		return "move"
