extends RigidBody2D

func _on_bullet_body_enter( body ):
	modulate = Color(1,1,1,1)
	$anim.play("idle")
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")

func _on_Timer_timeout():
	$anim.play("shutdown")
	queue_free()
