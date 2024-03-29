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
	host.get_node('StaggerTimer').start()
	host.get_node('AnimationPlayer').play('Stagger')
	side = host.get_node("sprite").scale.x


func update(host, delta):
	velocity = Vector2(-side*100,0)

	host.move_and_slide_with_snap(velocity, Vector2(0,32),Vector2(0,-1), 0, 4)
	
func _on_animation_finished(anim_name):
	if( anim_name == 'Stagger'):
		return 'fall'
