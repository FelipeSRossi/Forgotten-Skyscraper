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
	if event.is_action_pressed("melee"):
		return 'air slash'

func enter(host):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	host.get_node('AnimationPlayer').play('Jump-fall')
	horizontal_speed = MAX_RUN_SPEED

func update(host, delta):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	
	velocity = Vector2(input_direction * horizontal_speed, min(GRAVITY, velocity.y+ GRAVITY * delta))
				
	if(host.is_on_ceiling()):
		if(velocity.y < 0):
			velocity.y = 0
	
	host.move_and_slide (velocity,Vector2(0,-1), 0, 4)

	if host.is_on_floor():
		return 'move'
		
	if(host.is_on_wall() and input_direction != 0):
		return 'wall grab'



func exit(host):
	host.get_node('AnimationPlayer').play('Jump-landing')