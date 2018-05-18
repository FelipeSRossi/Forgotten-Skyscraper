extends RigidBody2D

func _ready():
	var others = get_parent().get_children()
	for i in others:
		if("bullet" in i.name):
			add_collision_exception_with(i)

func _on_bullet_body_enter( body ):
	modulate = Color(1,1,1,0.25)
	$anim.play("idle")
	$CollisionShape2D.disabled = true
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")

func _on_Timer_timeout():
	$anim.play("shutdown")
	queue_free()
