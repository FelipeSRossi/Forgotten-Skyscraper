extends 'on_ground.gd'

export(float) var MAX_RUN_SPEED = 150
export(float) var G = 50
export(float) var GRAVITY = 100.0
export(float) var JUMP_FORCE = 300.0

var PHASETWO = false
var movingon = false
var tired = false

func initialize(enter_velocity):
	velocity = enter_velocity
	

func enter(host):
	speed = 0.0
	var input_direction = get_input_direction()
	host.get_node('AnimationPlayer').play('Slide Slash')
	host.get_node('Hitbox').monitoring = true

func handle_input(host, event):
	return .handle_input(host, event)


func update(host, delta):
	
	if(!host.is_on_floor()):
		return 'fall'
	
	if(movingon):
		movingon=false
		return 'move'
		
	

	var input_direction = get_input_direction()

	if(!input_direction):
		return 'idle'

	speed = MAX_RUN_SPEED
	var collision_info = move(host, speed, input_direction)
	if not collision_info:
		return
	if collision_info.collider.is_in_group('environment'):
		return null
		


func move(host, speed, direction):
	var input_direction = get_input_direction()
	update_siding(host,input_direction)
	
	velocity = Vector2(input_direction *min(max(abs(velocity.x+velocity.x*1/10),MAX_RUN_SPEED) , 400), 0)

	host.move_and_slide_with_snap(velocity, Vector2(0,5),Vector2(0,-1), 0, 4)
	if host.get_slide_count() == 0:
		return
	return host.get_slide_collision(0)



func _on_animation_finished(anim_name):
	if(anim_name =='Slide Slash'):
		movingon = true
		
func exit(host):
	host.get_node('Hitbox').monitoring = false
	

