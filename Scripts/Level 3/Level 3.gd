extends Node2D

# Member variables
var viewport = null
var viewport_sprite = null
var alarm_state = 0
var alarm = false
var lifecounter
var tag = false
var tag2= false

var deviance = 100
signal cutscene(scene)
# variables for the sprite animation


func _ready():
	get_node("World/Overmap").visible = true
	viewport = get_node("Background/Viewport")
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
	Engine.set_target_fps(Engine.get_iterations_per_second())

	
func _on_camera_script_changed():
	pass # Replace with function body.


func _on_camera_alert():
	pass # Replace with function body.




func _on_BossDetect_body_entered(body):
	if(body.name == 'player') and !tag:
		get_node("CutsceneOverlay/Cutscene").start('res://Assets/cutscenes/data/dialogue-2.json')
		tag = true



func _on_BossDetect2_body_entered(body):
	if(body.name == 'player') and tag and !tag2:
		tag2 = true
		get_node("World/player/AnimationPlayer").play("Idle")
		get_tree().paused = true
		get_node("HUD/Warning/AnimationPlayer").play("Slide-in")




func _on_Warning_tree_exiting():
	get_tree().paused = false
	#get_node("World/Enemies/Boss").activate()
	#get_node("HUD/GUI2").visible = true
