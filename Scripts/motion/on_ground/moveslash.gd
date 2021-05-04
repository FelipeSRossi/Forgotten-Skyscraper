extends 'on_ground.gd'

export(float) var MAX_RUN_SPEED = 150
export(float) var G = 50
export(float) var GRAVITY = 100.0
export(float) var JUMP_FORCE = 300.0

var PHASETWO = false
var movingon = false
func enter(host):
	speed = 0.0
	velocity = Vector2()
	var input_direction = get_input_direction()
	var step = host.get_node('AnimationPlayer').get_current_animation_position()
	host.get_node('AnimationPlayer').play('Run Slash-1')
	host.get_node('AnimationPlayer').advance( step )
	get_node('Timer').start()
	

func handle_input(host, event):
	return .handle_input(host, event)


func update(host, delta):
	
	if(!host.is_on_floor()):
		if(host.get_node('AnimationPlayer4').current_animation == 'Slash effects'):
			return 'fall'
		else:
			return 'air slash'
	
	if(PHASETWO):
		var step = host.get_node('AnimationPlayer').get_current_animation_position()
		host.get_node('AnimationPlayer').play('Run Slash-2')
		host.get_node('AnimationPlayer').advance( step )
		host.get_node('AnimationPlayer4').play('Slash effects')
		PHASETWO = false
	
	if(movingon):
		movingon=false
		return 'move'

	var input_direction = get_input_direction()

	#if(!input_direction):
		#return 'idle'

	speed = MAX_RUN_SPEED
	var collision_info = move(host, speed, input_direction)
	if not collision_info:
		return
	if collision_info.collider.is_in_group('environment'):
		return null
		



func move(host, speed, direction):
	velocity = Vector2(direction * speed, 0)
	#host.move_and_slide(velocity, Vector2(0,-1), 0, 4)
	host.move_and_slide_with_snap(velocity,  Vector2(0,5),Vector2(0,-1), 0, 4)
	if host.get_slide_count() == 0:
		return
	return host.get_slide_collision(0)

func exit(host):
	host.get_node('Hitbox').monitoring = false
	get_node('Timer').stop()
	

func _on_Timer_timeout():
	PHASETWO = true
	


func _on_animation_finished(anim_name):
	if(anim_name =='Slash effects'):
		movingon = true

