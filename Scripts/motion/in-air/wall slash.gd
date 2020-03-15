extends '../motion.gd'

export(float) var GRAVITY =  100.0
export(float) var MAX_RUN_SPEED = 150

var enter_velocity = Vector2()
var velocity = Vector2()
var enter_input
var horizontal_speed = 0.0
var wall_grab = false


func initialize(input_direction,enter_velocity):
	velocity = enter_velocity
	enter_input = input_direction

func enter(host):
	var input_direction = get_input_direction()
	update_siding(host,-input_direction)
	host.get_node('AnimationPlayer').play('Wall Slash')
	horizontal_speed = MAX_RUN_SPEED


func handle_input(host, event):
	if event.is_action_pressed('jump'):
			return 'wall jump'



func update(host, delta):
	var input_direction = get_input_direction()
	update_siding(host,-input_direction)
	
	velocity = Vector2(input_direction * horizontal_speed, min(GRAVITY, velocity.y+ GRAVITY * delta * 12))
				
	if(host.is_on_ceiling()):
		if(velocity.y < 0):
			velocity.y = 0
	
	host.move_and_slide (velocity,Vector2(0,-1), 0, 4)
	
	
	if (!host.is_on_floor() and !host.is_on_wall()):
		return 'fall'
	
	if host.is_on_floor():
		return 'move'
	if (input_direction != enter_input):
		return 'fall'
	
	if(wall_grab):
		wall_grab = false
		return 'wall grab'

func exit(host):
	host.get_node('AnimationPlayer').play('Jump-landing')

func _on_animation_finished(anim_name):
	if( anim_name == 'Wall Slash'):
		wall_grab = true

