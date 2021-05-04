extends KinematicBody2D

# class member variables go here, for example:
onready var sprite = $Sprite
var stop = false
var original_pos
var direction = 1
var move_left = true
var move_right = false
var flicker = false
var health = 5
var bullet
var bigbullet
var shoot = false
var patrol = true
var explosion
const BULLET_VELOCITY = 100
const GRAVITY = 100
func _ready():
	get_node("AnimationPlayer").play("Run")
	original_pos = position





func hit_by_bullet():
	health = health - 1
	flicker = true
	
func hit_by_sword():
	health = health - 3
	flicker = true

func _process(delta):
	
	print(get_node("AnimationPlayer").current_animation)
	if(is_on_wall()):
		if(move_left):
			move_left = false
		else:
			move_left = true
	if(flicker):
		sprite.modulate = Color(10,10,10,10)
		flicker = false
	else:
		sprite.modulate = Color(1,1,1,1)
	
	if(health <= 0):
		explosion = preload("res://explosion.tscn").instance()
		explosion.position = $Sprite.global_position
		get_parent().add_child(explosion)
		queue_free()
	if(!is_on_floor()):
		move_and_slide(Vector2(0,5*GRAVITY), Vector2(0, -1), 0, 2);
		
	
	if(!patrol):
		if(shoot):
			get_node("AnimationPlayer").play("Shoot")
			direction = sign(global_position.x - get_parent().get_node("player/sprite").global_position.x)
			sprite.scale.x = direction
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
	else:
		if(!move_left and position.x >= (original_pos.x +100)):
			move_left = true
		elif(position.x <= (original_pos.x -100)):
			move_left = false
		
		if(move_left):
			sprite.scale.x = 1
			move_and_slide(Vector2(-25,GRAVITY), Vector2(0, -1), 0, 2);
		else:
			sprite.scale.x = -1
			move_and_slide(Vector2(25,GRAVITY), Vector2(0, -1), 0, 2);
			
			
	if(patrol):
		get_node("AnimationPlayer").play("Run")
	else:
		get_node("AnimationPlayer").play("Aim")
		if(shoot):
			get_node("AnimationPlayer").play("Shoot")
		
func _on_Scout_area_entered(area):
	pass
	


func _on_BulletTimer_timeout():
	shoot = true


func _on_Patrol__area_entered(area):
	if((area).name == "Hurtbox"):
		patrol = false
		get_node("BulletTimer").start()

func _on_Patrol__area_exited(area):
	if((area).name == "Hurtbox"):
		patrol = true

