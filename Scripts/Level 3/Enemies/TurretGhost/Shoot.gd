extends '../state.gd'

const BULLET_VELOCITY = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hide = false

func enter(host):
	host.get_node("AnimationPlayer").play("Wake")

func update(host, delta):
	host.get_node("AnimationPlayer").queue("Shoot")
	if(hide):
		hide = false
		return "hide"
	
func shoot(position, velocity):
	var bullet = preload("res://ScoutBullet.tscn").instance()
	
	bullet.position = get_parent().get_parent().get_node(position).global_position
	bullet.linear_velocity = Vector2((get_parent().get_parent().scale.x*velocity*BULLET_VELOCITY), 0) 
	bullet.add_collision_exception_with(get_parent().get_parent()) # don't want player to collide with bullet
	get_parent().add_child(bullet)


func _on_Patrol_body_entered(body):
	if(body.name == "player"):
		hide = true
