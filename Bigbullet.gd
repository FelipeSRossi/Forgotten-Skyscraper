extends RigidBody2D

func _ready():
	var others = get_parent().get_children()
	for i in others:
		if("bullet" in i.name):
			add_collision_exception_with(i)


func _on_Timer_timeout():
	$anim.play("shutdown")



func _on_Bigbullet_body_entered(body):
	$anim.play("idle")
	$CollisionShape2D.set_deferred( "disabled", true)
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
		queue_free()
