"""
The stagger state end with the stagger animation from the AnimationPlayer
The animation only affects the Body Sprite's modulate property so 
it could stack with other animations if we had two AnimationPlayer nodes
"""

extends 'motion.gd'
var enter_velocity = Vector2()

var max_horizontal_speed = 0.0
var speed = 0.0
var velocity = Vector2(0,0)
var side = 0


func enter(host):
	host.get_node("Hurtbox").set_deferred("monitoring",false)
	host.health = host.health - 10
	host.get_node('StaggerTimer').start()
	host.get_node('AnimationPlayer').play('Stagger')
	side = host.get_node("sprite").scale.x

	
func _on_animation_finished(anim_name):
	if( anim_name == 'Stagger'):
		get_tree().change_scene("res://DefaultMenu.tscn")
