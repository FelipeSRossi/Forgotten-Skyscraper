extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Spikes_body_entered(body):
	print(body)
	if body.has_method("hit_by_spikes"):
		body.call("hit_by_spikes")

func _on_Spikes_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.has_method("hit_by_spikes"):
		body.call("hit_by_spikes")
