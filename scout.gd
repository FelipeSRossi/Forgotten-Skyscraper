extends Node2D

# class member variables go here, for example:
var stop = false
var original_pos
var move_left = true
var move_right = false

func _ready():
	original_pos = position


func _on_collision( body ):
	print("calico")
	if body.has_method("hit_by_enemy"):
		body.call("hit_by_enemy")



func hit_by_bullet():
	stop = true
	pass

func _process(delta):
	if(!stop):
		if(move_left):
			move_local_x(0.3)
		elif(move_right):
			move_local_x(-0.3)
	
	

	if( move_right and position.x < (original_pos.x -20)):
		move_left = true
	elif(position.x == original_pos.x - 20):
		move_left = false
		
	if( move_left and position.x > (original_pos.x +20)):
		move_right = true
	elif(position.x == original_pos.x + 20):
		move_right = false
	