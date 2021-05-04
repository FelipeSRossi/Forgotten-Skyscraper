extends "res://Scripts/Enemy.gd"

# class member variables go here, for example:
var stop = false
var original_pos
var direction = 1
var move_left = true
var move_right = false
var bullet
var bigbullet
var shoot = false
var patrol = true
var cooldown = false
const BULLET_VELOCITY = 100
var explosion
func _ready():
	health = 3
	original_pos = position


func _physics_process(delta):
	
	if((cooldown) and get_node("Cooldown").is_stopped()):
		get_node("Cooldown").start()
	get_node("Patrol ").scale.x = get_node("Sprite").scale.x
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
	
	
	if(!patrol):
		direction =  sign(global_position.x - get_parent().get_parent().get_node("player/sprite").global_position.x)
		sprite.scale.x = direction
		if(shoot):
			get_node("AnimationPlayer").play("Shoot")
			
	
	else:
		if(!move_left and position.x >= (original_pos.x +100)):
			move_left = true
		elif(position.x <= (original_pos.x -100)):
			move_left = false

		if(move_left):
			sprite.scale.x = 1
			move_and_slide(Vector2(-25,0), Vector2(0, -1), 0, 2);
		else:
			sprite.scale.x = -1
			move_and_slide(Vector2(25,0), Vector2(0, -1), 0, 2);
		
func _on_Scout_area_entered(area):
	pass
	


func _on_BulletTimer_timeout():
	shoot = true


func _on_Patrol__area_entered(area):
	if((area).name == "Hurtbox" and !cooldown):
		patrol = false
		cooldown = true
		if(get_node("BulletTimer").is_stopped()):
			get_node("BulletTimer").start()

func _on_Patrol__area_exited(area):
	if((area).name == "Hurtbox" and !cooldown):
		patrol = true
		cooldown = true
		get_node("BulletTimer").stop()



func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == 'Shoot'):
			#scale.x = direction
			bullet = preload("res://ScoutBullet.tscn").instance()
			bigbullet = preload("res://ScoutBigBullet.tscn").instance()
			bullet.position = $Sprite/bullet_shoot.global_position #use node for shoot position
			bullet.scale.x = sprite.scale.x
			bullet.linear_velocity = Vector2((-sprite.scale.x * BULLET_VELOCITY ), 0) 
			bullet.add_collision_exception_with(self) # don't want player to collide with bullet
			get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
			shoot = false

			get_node("BulletTimer").start()
			get_node("AnimationPlayer").play("Hover")



func _on_HitStop_timeout():
	get_tree().paused = false
	pass # Replace with function body.


func _on_Cooldown_timeout():
	cooldown = false
