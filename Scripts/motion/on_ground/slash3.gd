extends '../motion.gd'
var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
var speed = 0.0
var velocity = Vector2(0,0)
var side = 0
var slash = false
var slash2 = false
func enter(host):
	host.get_node('AnimationPlayer').play('Slash 3')


func handle_input(host, event):
	return .handle_input(host, event)

func update(delta,host):
	
	if(slash):
		slash = false
		return 'idle'

func exit(host):
	host.get_node('Hitbox').monitoring = false
	
func _on_animation_finished(anim_name):
	if( anim_name == 'Slash 3'):
		velocity = Vector2(0,0)
		slash = true