extends '../motion.gd'

export(float) var GRAVITY = 100.0
export(float) var MAX_RUN_SPEED = 150
export(float) var JUMP_FORCE = 300.0

var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
var speed = 0.0
var velocity = Vector2()

var vertical_speed = 0.0
var height = 0.0
var still_jumping = true
var charge

func initialize( enter_velocity):
	speed = MAX_RUN_SPEED
	velocity = enter_velocity
	still_jumping = true
	
func handle_input(host, event):
	if event.is_action_released("jump"):
			still_jumping = false
	#if (event.is_action_pressed('shoot')): 
			#return 'divekick'


func enter(host):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	velocity.y =- JUMP_FORCE

	host.get_node('AnimationPlayer').play('Roll')


func update(host, delta):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)

	velocity = Vector2(input_direction * speed*2, min(GRAVITY*7, velocity.y+ GRAVITY*7*delta))

	
		#Allows for more precise jumping	
	if((!still_jumping) and velocity.y < 0):
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
		host.get_node('sprite').rotation_degrees = 0
