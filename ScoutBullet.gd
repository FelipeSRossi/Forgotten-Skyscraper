extends RigidBody2D
var red = false
func _ready():
	var others = get_parent().get_children()

		
	for i in others:
		if("bullet" in i.name):
			add_collision_exception_with(i)

func _on_bullet_body_enter( body ):
	$CollisionShape2D.set_deferred( "disabled", true)
	if body.has_method("hit_by_enemy_bullet"):
		body.call("hit_by_enemy_bullet")
		get_node("HitSound").play()
		queue_free()
	else:
		queue_free()
func _on_Timer_timeout():
	queue_free()

func _parried():
	queue_free()




func _on_HitSound_finished():
	queue_free()
