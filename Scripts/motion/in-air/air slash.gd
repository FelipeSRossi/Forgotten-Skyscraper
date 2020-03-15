extends '../motion.gd'

export(float) var GRAVITY =  100.0
export(float) var MAX_RUN_SPEED = 150

var enter_velocity = Vector2()
var velocity = Vector2()
var max_horizontal_speed = 0.0
var horizontal_speed = 0.0
var horizontal_velocity = Vector2()

var vertical_speed = 0.0
var height = 0.0


func initialize(enter_velocity):
	velocity = enter_velocity
	

func handle_input(host, event):
	pass

func enter(host):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	horizontal_speed = MAX_RUN_SPEED
	host.get_node('AnimationPlayer').play('Air Slash')

func update(host, delta):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	
	
	velocity = Vector2(input_direction * horizontal_speed,  velocity.y+ GRAVITY *5* delta)
	
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
	host.get_node('Hitbox').monitoring = false
	
func _on_animation_finished(anim_name):
	if(anim_name == 'Air Slash'):
		return 'fall'
