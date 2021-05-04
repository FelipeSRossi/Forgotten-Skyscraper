extends "res://Scripts/Enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Line = get_node("Line2D")
onready var Raycast = get_node("RayCast2D")
var gottem = false
var hat
var hattoggle = false
var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 3



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if(health <= 0):
		if(!hattoggle):
			hat = preload("res://Level 1/Enemies/hat.tscn").instance()
			hat.global_position = get_node("HatSpawn").global_position
			get_parent().add_child(hat)
			hattoggle = true
		var explosion = preload("res://explosion.tscn").instance()
		explosion.position = $Sprite.global_position
		get_parent().add_child(explosion)
		drop()
		queue_free()
	
	Line.points[0] =  Vector2(Raycast.position.x, 15)
	
	
	if(gottem):
		if(!hattoggle):
			hat = preload("res://Level 1/Enemies/hat.tscn").instance()
			hat.global_position = get_node("HatSpawn").global_position
			get_parent().add_child(hat)
			hattoggle = true
		get_node("AnimationPlayer").play("Attack")
		var velod  = Vector2(Line.points[0] - Line.points[1])
		move_and_slide(velod.normalized()* -450) 
	else:
		if(Raycast.is_colliding()):
			Line.points[1] = Raycast.get_collision_point() - Raycast.global_position + Vector2(0,15)
			if(Raycast.get_collider().name == 'player'):
				Line.points[1] = (Raycast.get_collision_point() - Raycast.global_position )*2
				gottem = true
			
		else:
			Line.points[1] =  Raycast.cast_to
	

	if(get_slide_count() > 1 and gottem):
		explosion = preload("res://explosion.tscn").instance()
		explosion.position = $Sprite.global_position
		get_parent().add_child(explosion)
		queue_free()
		
func _on_GuardBat_body_entered(body):
	if(gottem):
		explosion = preload("res://explosion.tscn").instance()
		explosion.position = $Sprite.global_position
		get_parent().add_child(explosion)
		queue_free()

	

func _on_HitStop_timeout():
	get_tree().paused = false
