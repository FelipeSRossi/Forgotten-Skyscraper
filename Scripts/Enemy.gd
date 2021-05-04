extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $Sprite
var deviance
var health = 9
var flicker = false

func hit_by_bullet():
	flicker = true
	health = health - 1
	
func hit_by_Medbullet():
	flicker = true
	health = health - 2
	
func hit_by_Bigbullet():
	flicker = true
	health = health - 3

	
func hit_by_sword():
	flicker = true
	get_node("HitStop").start()
	get_tree().paused = true
	health = health - 3
	

func hit_by_kick():
	flicker = true
	health = health - 3
	
func drop():
	deviance = get_parent().get_parent().get_parent().deviance
	randomize()
	var chance = randi() % deviance
	if(chance < 0.5):
		var item = preload("res://Powerups/Extra Life.tscn").instance()
		item.position = $Sprite.global_position
		item.position = $Sprite.global_position
		get_parent().add_child(item)
		get_parent().get_parent().get_parent().deviance = 100
	elif(chance < 2):
		var item = preload("res://Powerups/Big Health.tscn").instance()
		item.position = $Sprite.global_position
		item.position = $Sprite.global_position
		get_parent().add_child(item)
		get_parent().get_parent().get_parent().deviance = 100
	elif(chance < 5):
		var item = preload("res://Powerups/Medium Health.tscn").instance()
		item.position = $Sprite.global_position
		item.position = $Sprite.global_position
		get_parent().add_child(item)
		get_parent().get_parent().get_parent().deviance = 100
	elif(chance < 10):
		var item = preload("res://Powerups/Small Health.tscn").instance()
		item.position = $Sprite.global_position
		item.position = $Sprite.global_position
		get_parent().add_child(item)
		get_parent().get_parent().get_parent().deviance = 100
	else:
		get_parent().get_parent().get_parent().deviance -= 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	
	if(flicker):
		sprite.modulate = Color(10,10,10,10)
		flicker = false
	else:
		sprite.modulate = Color(1,1,1,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
