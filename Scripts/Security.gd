extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
signal alert

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Security")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("Sprite/Pivot/Patrol /CollisionShape2D/Polygon2D").color = Color(get_parent().alarm_state,243,255,123)
func player_was_discovered(host):
	if(get_node("Sprite").get_node("Pivot").get('inarea') == true):
		host.alarm_state = host.alarm_state + 1
	else:
		return false
		
func SHUTDOWN():
	pass
