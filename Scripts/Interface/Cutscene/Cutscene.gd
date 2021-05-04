extends Control
class_name Cutscene

signal dialogue_ended()

onready var portraits = {"Blue": {"default" : 0,"smile" : 1,"angry" : 2, "masked":3},"Green": {"default" : 4, "angry" : 5,"masked":6},"Control": {"default" : 7}}
onready var events = [1,10]
onready var dialogue_player  = get_node("DialoguePlayer")

export (String, FILE, "*.json") var dialogue_file_path : String

var anim_finished = true
var button_next
var button_finished 
var camera
var event = 0
signal dialogue_loaded(data)


func load_dialogue(file_path) -> Dictionary:
	# Parses a JSON file and returns it as a dictionary
	var file = File.new()
	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue

func ready():
	button_next  = get_node("TextureRect/TextureButton") 
	camera = get_parent().get_parent().get_node("World/player/Camera2D")
func start(dialogue_file_path) -> void:
	get_parent().get_parent().get_node("World/player").enter_cutscene()
	visible = true
	# Reinitializes the UI and asks the DialoguePlayer to 
	# play the dialogue
	#get_parent().get_parent().get_node("World/player/AnimationPlayer").play("Pose")
	#get_tree().paused = true
	button_next  = get_node("TextureRect/TextureButton") 
	var dialogue = load_dialogue(dialogue_file_path)
	button_next.show()
	button_next.grab_focus()

	dialogue_player.start(dialogue)
	update_content()
	show()

func _on_DialoguePlayer_finished() -> void:
	button_next.hide()
	emit_signal("dialogue_ended")
	anim_finished = true
	get_node("CutsceneAnimator").play("Green Ninja Fadeout")
	hide()
	get_parent().get_parent().get_node("World/player").exit_cutscene()


func update_content() -> void:
	for i in events:
		if(dialogue_player._index_current == i):
			anim_finished = false
			_on_Event()
	var dialogue_player_name = dialogue_player.title
	
	if(!anim_finished):
		button_next.disabled = true
		button_next.hide()
	
	get_node("TextureRect/RichTextLabel").text = dialogue_player.text
	get_node("TextureRect/TextAnimator").play("Text")
	get_node("TextureRect/Sprite").frame = portraits.get(dialogue_player_name).get(dialogue_player.expression)
func _on_Node2D_cutscene(scene):
	get_tree().paused
	visible = true
	



func _on_Event():
	if(event == 0):
		get_parent().get_parent().get_node("CutsceneOverlay/Cutscene/CutsceneAnimator").play("LVL1-Event2-1")
		event = event + 1
	elif(event == 1):
		get_parent().get_parent().get_node("CutsceneOverlay/Cutscene/CutsceneAnimator").play("LVL1-Event2-2")
		event = event + 1
	

func _on_TextureButton_pressed():
	dialogue_player.next()
	update_content()



func _on_CutsceneAnimator_animation_finished(anim_name):
	button_next.disabled = false
	button_next.show()
	button_next.grab_focus()
	anim_finished = true
