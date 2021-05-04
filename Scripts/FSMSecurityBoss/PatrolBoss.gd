# Collection of important methods to handle direction and animation
extends '../state.gd'

var move_left = true
var move_right = false
var shoot = false
var original_pos
var direction 
func enter(host):
	host.get_node("AnimationPlayer").play("Run")
	host.get_parent().get_parent().get_node("HUD/GUI2").set_visible(true)
	original_pos = host.position

func update(host, delta):
	
	if(host.get_node("States/Summon/SummonCooldown").is_stopped() and shoot == false):
		return 'summon'
	if(host.get_node("States/Melee/MeleeCooldown").is_stopped() and shoot == true):
		return 'melee'	
	host.get_node("AnimationPlayer").play("Run")
	direction = sign(host.global_position.x - host.get_parent().get_node("player/sprite").global_position.x)
	if(direction >= 1):
		host.sprite.scale.x = 1
		host.get_node('Scout2').scale.x = 1
		host.move_and_slide(Vector2(-40,host.GRAVITY), Vector2(0, -1), 0, 2);
	elif(direction <= -1):
		host.sprite.scale.x = -1
		host.get_node('Scout2').scale.x = -1
		host.move_and_slide(Vector2(40,host.GRAVITY), Vector2(0, -1), 0, 2);
	

func _on_Patrol__area_exited(area):
	if(area.name == 'Hurtbox'):
		shoot = false



func _on_Patrol__area_entered(area):
	if(area.name == 'Hurtbox'):
		shoot = true

