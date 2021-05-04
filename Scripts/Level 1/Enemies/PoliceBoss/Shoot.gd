# Collection of important methods to handle direction and animation
extends '../state.gd'

var move_left = true
var move_right = false
var shoot = false
var original_pos
var direction 
var walk = false
const BULLET_VELOCITY = 150
func enter(host):
	get_node("Timer").start()
	host.get_node("AnimationPlayer").play("Shoot Mode")
	original_pos = host.position
	

func update(host, delta):
	if(walk):
		walk = false
		return 'previous'
	host.get_node("AnimationPlayer").queue("Shooting")
	
	#return 'move'

func shoot(position, velocity, color):
	var bullet = preload("res://Level 1/Enemies/PoliceBossBullet.tscn").instance()
	if(color== 1):
		bullet.red = true
	elif(color == 2):
		bullet.red = false
	bullet.position = get_parent().get_parent().get_node(position).global_position
	bullet.linear_velocity = Vector2((-get_parent().get_parent().scale.x*velocity*BULLET_VELOCITY*rand_range(1, 1.5)), 0) 
	bullet.add_collision_exception_with(get_parent().get_parent().get_node("LeftArm")) # don't want player to collide with bullet
	bullet.add_collision_exception_with(get_parent().get_parent().get_node("RightArm"))
	bullet.add_collision_exception_with(get_parent().get_parent().get_node("Torso"))
	get_parent().add_child(bullet)

func exit(host):
	host.get_node("AnimationPlayer").play("Walk Mode")
	original_pos = host.position

func _on_Timer_timeout():
	walk = true

