extends KinematicBody2D

# class member variables go here, for example:
var stop = false
var original_pos
var move_left = true
var move_right = false

func _ready():
	original_pos = position





func hit_by_bullet():
	stop = true
	pass

func _process(delta):
	if(!stop):
		if(move_left):
			move_and_slide(Vector2(3,0), Vector2(0, -1), 0, 2);
		elif(move_right):
			move_and_slide(Vector2(-3,0), Vector2(0, -1), 0, 2);
	
	

	if( move_right and position.x < (original_pos.x -20)):
		move_left = true
	elif(position.x == original_pos.x - 20):
		move_left = false
		
	if( move_left and position.x > (original_pos.x +20)):
		move_right = true
	elif(position.x == original_pos.x + 20):
		move_right = false
	