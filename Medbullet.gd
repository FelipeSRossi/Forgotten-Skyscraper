extends RigidBody2D
var curpo
func _ready():
	var others = get_parent().get_children()
	curpo = position
	for i in others:
		if("bullet" in i.name):
			add_collision_exception_with(i)

func _on_bullet_body_enter( body ):
	modulate = Color(1,1,1,0.25)
	$anim.play("idle")
	$CollisionShape2D.set_deferred( "disabled", true)
	if body.has_method("hit_by_Medbullet"):
		body.call("hit_by_Medbullet")
		get_node("HitSound").play()

func _on_Timer_timeout():
	$anim.play("shutdown")


func _physics_process(delta):
	if(abs(position.x) > 250 + abs(curpo.x) or abs(position.x) < abs(curpo.x) - 250):
		queue_free()


func _on_HitSound_finished():
	queue_free()
