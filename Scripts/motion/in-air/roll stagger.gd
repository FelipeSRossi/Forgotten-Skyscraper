extends '../motion.gd'

export(float) var GRAVITY = 100.0
export(float) var MAX_RUN_SPEED = 150
export(float) var JUMP_FORCE = 300.0

var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
var speed = 0.0
var velocity = Vector2()
var rolling = false
var vertical_speed = 0.0
var height = 0.0
var still_jumping = true
var side
func initialize( enter_velocity):
	speed = MAX_RUN_SPEED
	velocity = enter_velocity
	still_jumping = true

func enter(host):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	velocity.x = -velocity.x*2
	host.get_node('AnimationPlayer').play('Roll')
	get_node("Timer").start()
	side = host.get_node("sprite").scale.x
func update(host, delta):
	var input_direction = get_input_direction()

	velocity = Vector2(velocity.x-side*30,-JUMP_FORCE/3)

	host.move_and_slide_with_snap(velocity, Vector2(0,32),Vector2(0,-1), 0, 4)

		
	if(host.is_on_ceiling()):
		if(velocity.y < 0):
			velocity.y = 0
	
	if(rolling):
		rolling  = false
		return 'fall'
	
	if host.is_on_floor():
		return 'move'
	
	if(host.is_on_wall() and input_direction != 0):
		return 'wall grab'
func exit(host):
		host.get_node('sprite').rotation_degrees = 0
		velocity = Vector2(0,0) 
func _on_Timer_timeout():
	rolling = true
