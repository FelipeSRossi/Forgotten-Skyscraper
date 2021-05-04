extends '../state.gd'

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var end
# Called when the node enters the scene tree for the first time.
func enter(host):
	end = false
	host.get_node("AnimationPlayer").play("Dash")
	host.get_node("Sprite/SlashPlayer").play("SlashSprite")
	get_node("MeleeCooldown").start()

func update(host,delta):
	var direction = sign(host.global_position.x - host.get_parent().get_node("player/sprite").global_position.x)
	if(direction >= 1):
		host.sprite.scale.x = 1
		host.get_node('Scout2').scale.x = 1
		host.move_and_slide(Vector2(-100,host.GRAVITY), Vector2(0, -1), 0, 2);
	elif(direction <= -1):
		host.sprite.scale.x = -1
		host.get_node('Scout2').scale.x = -1
		host.move_and_slide(Vector2(100,host.GRAVITY), Vector2(0, -1), 0, 2);
	#print(get_node("SummonCooldown").time_left)
	if(end):
		end = false
		return 'patrol'
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func exit(host):
	host.get_node("Scout2").monitorable = false


func _on_SlashPlayer_animation_finished(anim_name):
	if(anim_name == 'SlashSprite'):
		end = true
