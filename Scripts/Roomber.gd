extends "res://Scripts/Enemy.gd"

# class member variables go here, for example:
var stop = false
var velocity = Vector2()
var original_pos
var direction = 1
var move_left = true
var move_right = false
var patrol = true
var spin = false
const BULLET_VELOCITY = 100
const GRAVITY = 150
var explosion
func _ready():
	health = 3
	get_node("AnimationPlayer").play("roam")
	original_pos = position




func _process(delta):
	if(is_on_wall()):
		if(move_left):
			move_left = false
		else:
			move_left = true
	if(health <= 0):
		explosion = preload("res://explosion.tscn").instance()
		explosion.position = $Sprite.global_position
		get_parent().add_child(explosion)
		drop()
		queue_free()
	
	
	if(!patrol and spin):
		get_node("AnimationPlayer").queue("Spin")
		
		move_and_slide(Vector2(get_parent().get_parent().get_node("player").scale.x*-270, GRAVITY), Vector2(0, -1), 0, 2);
	
	else:
		if(!move_left and position.x >= (original_pos.x +100)):
			move_left = true
		elif(position.x <= (original_pos.x -100)):
			move_left = false

		if(move_left):
			sprite.scale.x = 1
			move_and_slide(Vector2(-75,GRAVITY), Vector2(0, -1), 0, 2);
		else:
			sprite.scale.x = -1
			move_and_slide(Vector2(75,GRAVITY), Vector2(0, -1), 0, 2);
		
func _on_Scout_area_entered(area):
	pass
	

func _on_Patrol__area_entered(area):
	if((area).name == "Hurtbox" and patrol == true):
		get_node("AnimationPlayer").play("Activate")
		patrol = false

func _on_Patrol__area_exited(area):
	pass
	




func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "Activate"):
		spin = true
		position.y = position.y -5


func _on_HitStop_timeout():
	get_tree().paused = false
