"""
The stagger state end with the stagger animation from the AnimationPlayer
The animation only affects the Body Sprite's modulate property so 
it could stack with other animations if we had two AnimationPlayer nodes
"""
extends '../state.gd'

const BULLET_VELOCITY = 300



func enter(host):
	var bullet = preload("res://bullet.tscn").instance()
	host.get_node('AnimationPlayer').play('Shoot')
	bullet.position = host.get_node('sprite').get_node('bullet_shoot').global_position #use node for shoot position
	bullet.linear_velocity = Vector2(host.sprite.scale.x * BULLET_VELOCITY, 0)
	bullet.add_collision_exception_with(host) # don't want player to collide with bullet
	host.get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent


func _on_animation_finished(anim_name):
	return 'previous'

