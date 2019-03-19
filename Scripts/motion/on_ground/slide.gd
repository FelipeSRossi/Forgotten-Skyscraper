extends 'on_ground.gd'

export(float) var MAX_RUN_SPEED = 150
export(float) var G = 50


func enter(host):
	speed = 0.0
	velocity = Vector2()
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	host.get_node('AnimationPlayer').play('Slide-start')
	host.get_node('AnimationPlayer').queue('Slide')
	

func handle_input(host, event):
	if event.is_action_released('slide'):
		return 'move'
	if event.is_action_pressed('jump'):
		return 'roll'
	return .handle_input(host, event)


func update(host, delta):
	if(!host.is_on_floor()):
		return 'fall'
	
	
	
	var new_input_direction = get_input_direction()
	if(new_input_direction != get_input_direction()):
		update_siding(host,new_input_direction)
		return 'move'
	
	if(!new_input_direction):
		return 'idle'

	speed = MAX_RUN_SPEED
	var collision_info = move(host, speed, new_input_direction)
	if not collision_info:
		return
	if collision_info.collider.is_in_group('environment'):
		return null
	

func move(host, speed, direction):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	velocity = Vector2(input_direction * speed*2.5, G)
	host.move_and_slide(velocity, Vector2(0,-1), 0, 4)
	if host.get_slide_count() == 0:
		return
	return host.get_slide_collision(0)
	
func _on_animation_finished(animation):
	if(animation == 'Slide'):
			return 'move'