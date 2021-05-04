# Collection of important methods to handle direction and animation
extends '../state.gd'

var move_left = true
var move_right = false
var shoot = false
var original_pos
var direction 
func enter(host):
	host.get_node("AnimationPlayer").play("Run")
	original_pos = host.position
	shoot = false
func update(host, delta):
	if(shoot):
		return "shoot"
	host.get_node("AnimationPlayer").play("Run")
	if(!move_left and host.position.x >= (original_pos.x +100)):
		move_left = true
	elif(host.position.x <= (original_pos.x -100)):
		move_left = false
		
	if(move_left):
		host.get_node('Sprite').scale.x = 1
		host.move_and_slide(Vector2(-40,host.GRAVITY), Vector2(0, -1), 0, 2);
	else:
		host.get_node('Sprite').scale.x = -1
		host.move_and_slide(Vector2(40,host.GRAVITY), Vector2(0, -1), 0, 2);	

func _on_Patrol__area_exited(area):
	
	pass # Replace with function body.


func _on_Patrol__area_entered(area):
	if(area.name == 'Hurtbox'):
		shoot = true

