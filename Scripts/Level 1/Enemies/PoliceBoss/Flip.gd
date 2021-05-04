extends '../state.gd'


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var move_left
var flipper = false
# Called when the node enters the scene tree for the first time.
func enter(host):
	move_left = get_parent().get_node("Move").move_left


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(host, delta):
	if(flipper):
		flipper = false
		if(move_left):
			host.get_node("AnimationPlayer").play("Flip Left")
		else:
			host.get_node("AnimationPlayer").play("Flip Right")
	
	
	if(host.animation_finished):
		host.animation_finished = false
	
		return 'previous'


func exit(host):
	host.get_node("AnimationPlayer").play("Walk")
	
func flipper():
	flipper = true

func flipper_no():
	flipper = false
