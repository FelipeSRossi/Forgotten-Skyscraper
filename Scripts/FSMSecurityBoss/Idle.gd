# Collection of important methods to handle direction and animation
extends '../state.gd'

var move_left = true
var move_right = false
var patrol = false
var original_pos
var direction 
func enter(host):
	host.get_node("AnimationPlayer").play("Idle")
	original_pos = host.position

func update(host, delta):
	if(patrol):
		return 'patrol'
		
func _on_Patrol__area_entered(area):
	if(area.name == 'Hurtbox'):
		patrol = true
