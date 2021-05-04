# Collection of important methods to handle direction and animation
extends '../state.gd'

var move_left = false
var previous_move = false
var shoot = false
var flipper
var timetosh
var original_pos
func enter(host):
	host.get_node("AnimationPlayer").queue("Walk")
	original_pos = host.position
	host.get_node("LeftArm/Scout").monitoring = true
func update(host, delta):
	
	
	
	host.get_node("AnimationPlayer").queue("Walk")
	flipper = get_parent().get_node("Flip").flipper

	if(shoot):
		shoot = false
		return 'shoot'
		
		
	if(!move_left and host.position.x >= original_pos.x + 290):
		move_left = true

			
	elif(host.position.x <= original_pos.x - 60) :
		move_left = false
	
	if(previous_move != move_left):
		previous_move = move_left
		shoot = true
		return 'flip'
	
	
	if(!flipper):
		if(move_left):
			host.translate(Vector2(-1.5,0))
		else:
			host.translate(Vector2(1.5,0))
		
	
