extends Node2D

# Member variables
var viewport = null
var viewport_sprite = null
var alarm_state = 0
var alarm = false
var lifecounter
var tag = false
var tag2= false
var bossSpawn = true
onready var checkpoints = ["World/Checkpoint0","World/Checkpoint1","World/Checkpoint2"]

onready var player_vars = get_node("/root/GlobalVar")


var deviance = 80
signal cutscene(scene)
# variables for the sprite animation


func _ready():
	get_node("World/Overmap").visible = true
	viewport = get_node("Background/Viewport")
	viewport_sprite = get_node("Background").get_node("Viewport_Sprite")
	lifecounter = get_node("HUD/GUI/HealthBar/LifeCounter")
	get_node("World/player").position = get_node(checkpoints[player_vars.checkpoint]).position
	lifecounter.frame = player_vars.lives
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
	if(body.name == 'player') and !tag and !player_vars.cutscene:
		get_node("CutsceneOverlay/Cutscene").start('res://Assets/cutscenes/data/dialogue-2.json')
		tag = true



func _on_BossDetect2_body_entered(body):
	if(body.name == 'player') and (player_vars.cutscene) and bossSpawn:
		get_node("World/player").enter_cutscene()
		get_node("HUD/Warning/AnimationPlayer").play("Slide-in")
		get_node("CutsceneOverlay/Cutscene/TextureRect/AnimationPlayer").play("LVL1-BossSpawn")
		bossSpawn = false
	elif(body.name == 'player') and (tag and !tag2):
		tag2 = true
		get_node("World/player").enter_cutscene()
		#get_tree().paused = true
		get_node("HUD/Warning/AnimationPlayer").play("Slide-in")
		bossSpawn = false


func _on_Warning_tree_exiting():
	#get_tree().paused = false
	get_node("World/Enemies/Boss").activate()
	get_node("World/player").exit_cutscene()
	get_node("HUD/GUI2").visible = true
	player_vars.cutscene = true
		
func _on_Checkpoint0_body_entered(body):
	if(body.name == 'player'):
		player_vars.checkpoint = 0

func _on_Checkpoint1_body_entered(body):
	if(body.name == 'player'):
		player_vars.checkpoint = 1

func _on_Checkpoint2_body_entered(body):
	if(body.name == 'player'):
		player_vars.checkpoint = 2
