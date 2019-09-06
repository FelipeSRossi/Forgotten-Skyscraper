extends '../motion.gd'

export(float) var GRAVITY = 100.0
export(float) var MAX_RUN_SPEED = 150


var enter_velocity = Vector2()
var velocity = Vector2()
var max_horizontal_speed = 0.0
var horizontal_speed = 0.0
var horizontal_velocity = Vector2()

var vertical_speed = 0.0
var height = 0.0


func initialize( enter_velocity):
	velocity = enter_velocity



func enter(host):
	
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	host.get_node('AnimationPlayer').play('Air Slash')
	horizontal_speed = MAX_RUN_SPEED
	


func update(host, delta):
	pass

func exit(host):
	host.get_node('sprite').rotation_degrees = 0

func _on_animation_finished(anim_name):
	if(anim_name == 'Air Slash'):
		return 'previous'