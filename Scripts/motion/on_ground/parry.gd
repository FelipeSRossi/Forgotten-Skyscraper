extends '../motion.gd'
var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
var speed = 0.0
var velocity = Vector2(0,0)
var side = 0


func enter(host):
	host.get_node('AnimationPlayer').play('Absorb')

func handle_input(host, event):
	return .handle_input(host, event)

func exit(host):
	host.get_node('Parry').monitoring = false
	
func _on_animation_finished(anim_name):
	if( anim_name == 'Absorb'):
		velocity = Vector2(0,0)
		return 'idle'
	
func update(host, delta):
	if(!host.is_on_floor()):
		return 'fall'

	var input_direction = get_input_direction()
	update_siding(host,input_direction)


func _on_Parry_body_entered(body):
		if body.has_method("_parried"):
			body.call("_parried")

