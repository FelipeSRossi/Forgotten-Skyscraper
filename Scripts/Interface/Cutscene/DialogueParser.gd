# Base command interface for all actions the player 
# or a character can perform on the map
# Uses a reference to the LocalMap to start interactions
# and wait for events to complete with coroutines
extends Node

class_name DialogueAction

export (String, FILE, "*.json") var dialogue_file_path : String
signal dialogue_loaded(data)
signal finished()
var local_map
var active : bool = true


func initialize(_local_map):
	local_map = _local_map


func interact() -> void:
	var dialogue : Dictionary =  load_dialogue(dialogue_file_path)
	yield(local_map.play_dialogue(dialogue), "completed")
	emit_signal("finished")

func load_dialogue(file_path) -> Dictionary:
	# Parses a JSON file and returns it as a dictionary
	var file = File.new()
	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert(dialogue.size() > 0)
	return dialogue
