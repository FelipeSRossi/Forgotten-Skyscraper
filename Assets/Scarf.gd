extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var charge

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	charge = get_parent().get_parent().charge
	set_emission_sphere_radius(charge/9)
	initial_velocity = 223 - charge*2
	self_modulate = Color(0.63,charge/10 + 0.69,0.79)
	scale_amount = 0.3 + charge/100
	orbit_velocity = charge/10
	if(charge >= 100):
		set_emission_sphere_radius(3.5)
		self_modulate = Color(1,1,5)
		initial_velocity = 223
		scale_amount = 0.6
		orbit_velocity = 0
	else:
		pass
