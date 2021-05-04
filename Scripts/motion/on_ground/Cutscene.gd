extends 'on_ground.gd'

export(float) var GRAVITY =  7000.0
func enter(host):
	speed = 0.0
	velocity = Vector2()
	
	if(host.get_node('AnimationPlayer').current_animation == 'Jump-landing'):
		host.get_node('AnimationPlayer').queue('Idle')
	else:
		host.get_node('AnimationPlayer').play('Idle')
	

func handle_input(host, event):
	pass

func update(host, delta):
	if(!host.is_on_floor()):
		host.move_and_slide(Vector2(0,min(GRAVITY*2, velocity.y+ GRAVITY*2 * delta)),Vector2(0,-1), 0, 4)
		host.get_node('AnimationPlayer').play('Jump-fall')
	else:
		host.get_node('AnimationPlayer').play('Pose')
