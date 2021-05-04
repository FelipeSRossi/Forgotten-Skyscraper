extends '../state.gd'


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shoot = false

func enter(host):
	host.get_node("AnimationPlayer").play("Hide")

func update(host, delta):
	if(shoot):
		shoot = false
		return "shoot"


func _on_Patrol_body_exited(body):
		if(body.name == "player"):
			shoot = true
