extends "res://Scripts/Enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var left = false
var attack = false


const BULLET_VELOCITY = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	health = 9

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):

	var signal = sign(get_parent().get_parent().get_node("player").position.x - position.x)
	if(signal < 0):
		left = true
	elif(signal >0):
		left = false
		
	if(health < 9):
		attack = true
	
	if(attack and left):
		get_node("AnimationPlayer").play('Attack Left')
	elif(attack and !left):
		get_node("AnimationPlayer").play('Attack Right')
	elif(!attack and left):
		get_node("AnimationPlayer").play('Stop Left')
	#elif(!attack and !left):
		#get_node("AnimationPlayer").play('Stop Right')
	if(health <= 0):
		var explosion = preload("res://explosion.tscn").instance()
		explosion.position = $Sprite.global_position
		get_parent().add_child(explosion)
		drop()
		queue_free()
	

func shoot(position, velocity):
	var bullet = preload("res://ScoutBullet.tscn").instance()
	bullet.position = get_node(position).global_position
	bullet.linear_velocity = Vector2((velocity*BULLET_VELOCITY ), 0) 
	bullet.add_collision_exception_with(self) # don't want player to collide with bullet
	get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent

func _on_Area2D_body_entered(body):
	if(body.name == 'player'):
		attack = true
	


func _on_Area2D_body_exited(body):
	if(body.name == 'player'):
		attack = false


func _on_HitStop_timeout():
	get_tree().paused = false

