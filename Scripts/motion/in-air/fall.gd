extends '../motion.gd'

export(float) var GRAVITY = 450.0

export(float) var JUMP_FORCE = 300.0

var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
var horizontal_speed = 0.0
var horizontal_velocity = Vector2()

var vertical_speed = 0.0
var height = 0.0
var still_jumping = true


func initialize(speed, velocity):
	horizontal_speed = speed
	enter_velocity = velocity
	still_jumping = true

func handle_input(host, event):
	if event.is_action_released("jump"):
			still_jumping = false



func enter(host):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	enter_velocity.y =- JUMP_FORCE
	host.get_node('AnimationPlayer').play('Jump-start')


func update(host, delta):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	
	enter_velocity = Vector2(input_direction * horizontal_speed, min(GRAVITY, enter_velocity.y+ GRAVITY * delta))
	
		#Allows for more precise jumping	
	if((!still_jumping) and enter_velocity.y < 0):
		enter_velocity.y = enter_velocity.y / 2
			
	if(host.is_on_ceiling()):
		if(enter_velocity.y < 0):
			enter_velocity.y = 0
	
	host.move_and_slide (enter_velocity,Vector2(0,-1), 0, 1)
	if(enter_velocity.y < 0):
		print("Rising Tackle")
		host.get_node('AnimationPlayer').queue('Jump-rise')
	elif(enter_velocity.y > 0):
		print("crestfallen")
		host.get_node('AnimationPlayer').play('Jump-fall')
	
	if host.is_on_floor():
		print("booper")
		host.get_node('AnimationPlayer').play('Jump-landing')
		return 'previous'

