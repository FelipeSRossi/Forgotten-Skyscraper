extends '../state.gd'

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var end
var minion
# Called when the node enters the scene tree for the first time.
func enter(host):
	end = false
	host.get_node("AnimationPlayer").play("Summon")
	minion = preload("res://Sentry.tscn").instance()
	minion.position = Vector2(host.sprite.global_position.x + 20,host.sprite.global_position.y - 40) #use node for shoot position
	minion.scale.x = host.sprite.scale.x
	minion.get_node('control').add_collision_exception_with(host)
	host.get_parent().add_child(minion) #don't want bullet to move with me, so add it as child of parent
	get_node("SummonCooldown").start()
	
func update(host,delta):
	
	#print(get_node("SummonCooldown").time_left)
	if(end):
		end = false
		return 'patrol'
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == 'Summon'):
		end = true
