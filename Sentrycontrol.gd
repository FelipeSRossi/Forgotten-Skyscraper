extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var original_pos
var patrol = true
var move_left = true
var move_right = false
onready var sprite = $Sprite
var shoot = false
var flicker = false
var health = 3
var bullet
var bigbullet
var explosion
const BULLET_VELOCITY = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	original_pos = position
	var objective = get_parent().radius


func hit_by_bullet():
	health = health - 1
	flicker = true
	
func hit_by_sword():
	health = health - 3
	flicker = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(flicker):
		sprite.modulate = Color(10,10,10,10)
		get_parent().get_node("Sprite2").modulate = Color(10,10,10,10)
		flicker = false
	else:
		sprite.modulate = Color(1,1,1,1)
		get_parent().get_node("Sprite2").modulate = Color(1,1,1,1)
	if(health <= 0):
		explosion = preload("res://explosion.tscn").instance()
		explosion.position = $Sprite.global_position
		get_parent().get_parent().add_child(explosion)
		get_parent().queue_free()
	if(shoot and !patrol):
		bullet = preload("res://ScoutBullet.tscn").instance()
		bigbullet = preload("res://ScoutBigBullet.tscn").instance()

		bullet.position = global_position #use node for shoot position
		bullet.linear_velocity = -((get_node("Sprite").global_position - get_parent().get_parent().get_parent().get_node("player").global_position)*BULLET_VELOCITY*delta) 
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		shoot = false
		get_node("BulletTimer").start()
	
	
	if(patrol):
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
	else:
		get_parent().radius
		
			
func _on_Scout_area_entered(area):
	pass
	


func _on_BulletTimer_timeout():
	shoot = true


func _on_Patrol__area_entered(area):
	if((area).name == "Hurtbox"):
		patrol = false
		pass

func _on_Patrol__area_exited(area):
	if((area).name == "Hurtbox"):
		pass
