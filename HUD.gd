extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("GUI/HealthBar").value = get_parent().get_node("player").health
	if(get_parent().get_node("SecurityBoss").health ):
		get_node("GUI2/BossHealthBar").value = get_parent().get_node("SecurityBoss").health 
	else:
		get_node("GUI2/BossHealthBar").value = 0
