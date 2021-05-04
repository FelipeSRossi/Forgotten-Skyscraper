# Collection of important methods to handle direction and animation
extends '../state.gd'

var direction
var bullet
var bigbullet
var shoot = true
var returns = false
var returncounter = 0
func update_siding(host, input_direction):
	if(input_direction):
		host.get_node("sprite").scale.x = input_direction
		host.get_node("Hitbox").scale.x = input_direction
		host.get_node("Hurtbox").scale.x = input_direction
	return
	

func enter(host):
	host.get_node("AnimationPlayer").play("Aim")


func update(host, delta):
	print(returncounter)
	if(returns):
		returncounter = returncounter + 1
		if(returncounter > 20):
			returncounter = 0
			return 'patrol'
	
	if(shoot):
		host.get_node("AnimationPlayer").play("Shoot")
		direction = sign(host.global_position.x - host.get_parent().get_parent().get_node("player/sprite").global_position.x)
		host.sprite.scale.x = direction
		bullet = preload("res://ScoutBullet.tscn").instance()
		bigbullet = preload("res://ScoutBigBullet.tscn").instance()
		bullet.position = host.sprite.get_node("bullet_shoot").global_position #use node for shoot position
		bullet.scale.x = host.sprite.scale.x
		bullet.linear_velocity = Vector2((-host.sprite.scale.x * host.BULLET_VELOCITY ), 0) 
		bullet.add_collision_exception_with(host) # don't want player to collide with bullet
		get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		shoot = false
		host.get_node("BulletTimer").start()
	
	
func _on_BulletTimer_timeout():
	shoot = true



func _on_Patrol__area_exited(area):
	if(area.name == 'Hurtbox'):
		returns = true



func _on_Patrol__area_entered(area):
	if(area.name == 'Hurtbox'):
		returns = false
