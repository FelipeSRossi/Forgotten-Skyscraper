extends '../motion.gd'

export(float) var GRAVITY =  300.0
export(float) var MAX_RUN_SPEED = 150
export(float) var JUMP_FORCE = 300.0

var enter_velocity = Vector2()
var velocity = Vector2()
var enter_input = 0.0
var max_horizontal_speed = 0.0
var horizontal_speed = 0.0
var horizontal_velocity = Vector2()
var speed = 0.0
var vertical_speed = 0.0
var height = 0.0
var frame_time = 0
var timeout = false
func initialize(input_direction,enter_velocity):
	velocity = enter_velocity


func enter(host):
	timeout = false
	var input_direction = get_input_direction()
	enter_input = input_direction
	speed = -MAX_RUN_SPEED*3*enter_input
	velocity = Vector2(speed, -JUMP_FORCE)
	update_siding(host,input_direction)
	host.get_node('AnimationPlayer').play('Jump-start')
	host.get_node('AnimationPlayer').queue('Jump-rise')
	get_node("Timer").start()


func update(host, delta):
	velocity = Vector2(speed, min(GRAVITY, velocity.y+ GRAVITY*delta))
	host.move_and_slide (velocity,Vector2(0,-1), 0, 4)
	if(timeout):
		return 'jump'

func exit(host):
	host.get_node('AnimationPlayer').play('Jump-landing')

func _on_Timer_timeout():
		 timeout = true
