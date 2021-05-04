extends RigidBody2D
var curpo
func _ready():
	var others = get_parent().get_children()
	curpo = position
	for i in others:
		if("bullet" in i.name):
			add_collision_exception_with(i)
	

func _on_Timer_timeout():
	$anim.play("shutdown")



func _on_Area2D_body_entered(body):
	$CollisionShape2D.set_deferred( "disabled", true)
	if body.has_method("hit_by_Bigbullet"):
		body.call("hit_by_Bigbullet")

func _on_Bigbullet_body_entered(body):
	$anim.play("idle")
	$CollisionShape2D.set_deferred( "disabled", true)
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
		queue_free()

func _physics_process(delta):
	if(abs(position.x) > 250 + abs(curpo.x)):
		queue_free()
