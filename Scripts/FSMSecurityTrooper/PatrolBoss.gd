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

func update(host, delta):
		
	host.get_node("AnimationPlayer").play("Run")
	direction = sign(host.global_position.x - host.get_parent().get_node("player/sprite").global_position.x)
	if(direction >= 1):
		host.sprite.scale.x = 1
		host.move_and_slide(Vector2(-40,host.GRAVITY), Vector2(0, -1), 0, 2);
	elif(direction <= -1):
		host.sprite.scale.x = -1
		host.move_and_slide(Vector2(40,host.GRAVITY), Vector2(0, -1), 0, 2);
	

func _on_Patrol__area_exited(area):
	
	pass # Replace with function body.


func _on_Patrol__area_entered(area):
	if(area.name == 'Hurtbox'):
		shoot = true

