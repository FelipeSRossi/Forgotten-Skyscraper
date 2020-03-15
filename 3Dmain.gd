extends Node2D

# Member variables
var viewport = null
var viewport_sprite = null
var alarm_state = 0
var alarm = false
var lifecounter
# variables for the sprite animation


func _ready():
	viewport = get_node("Viewport")
	viewport_sprite = get_node("Background").get_node("Viewport_Sprite")
	lifecounter = get_node("HUD/GUI/HealthBar/LifeCounter")
	lifecounter.frame = 3
	# Assign the sprite's texture to the viewport texture
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	# Let two frames pass to make sure the screen was captured
	#yield(get_tree(), "idle_frame")
	#yield(get_tree(), "idle_frame")
	viewport_sprite.texture = viewport.get_texture()
  
	set_process(true)

func _process(delta):
	get_tree().call_group("Security", "player_was_discovered", self)
	if(alarm_state > 100):
		get_tree().call_group("Security", "ALARM")
		get_node("Siren").play("Sirens")
	else:
		get_node("Siren").play("Stopped")

	
func _on_camera_script_changed():
	pass # Replace with function body.


func _on_camera_alert():
	pass # Replace with function body.
