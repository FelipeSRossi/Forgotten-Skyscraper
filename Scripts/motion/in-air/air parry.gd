extends '../motion.gd'

export(float) var GRAVITY =  100.0
export(float) var MAX_RUN_SPEED = 150

var velocity = Vector2()
var horizontal_speed = 0.0
var enter_velocity = Vector2()
var cancel = false
func initialize(enter_velocity):
	velocity = enter_velocity
	

func handle_input(host, event):
	if event.is_action_released('parry'):
		return 'fall'
	

func enter(host):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	horizontal_speed = MAX_RUN_SPEED
	host.get_node('AnimationPlayer').play('Air Parry')

func update(host, delta):
	
		
	
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	
	
	velocity = Vector2(0,  velocity.y+ GRAVITY *5* delta)
	
	if( velocity.y < 0):
		velocity.y = velocity.y / 2
				
	if(host.is_on_ceiling()):
		if(velocity.y < 0):
			velocity.y = 0
	
	host.move_and_slide (velocity,Vector2(0,-1), 0, 4)
	
	if host.is_on_floor():
		return 'move'
		
	if(host.is_on_wall() and input_direction != 0):
		return 'wall grab'



func exit(host):
	host.get_node('Parry').monitoring = false
	
func _on_animation_finished(anim_name):
	#if(anim_name == 'Air Parry'):
		#return 'fall'
		pass
