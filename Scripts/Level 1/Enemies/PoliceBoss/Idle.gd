# Collection of important methods to handle direction and animation
extends '../state.gd'

var move_left = true
var move_right = false
var shoot = false
var original_pos
var direction 

const BULLET_VELOCITY = 150
func enter(host):
	original_pos = host.position
	

func update(host, delta):
	
	pass
	
