extends KinematicBody2D

# This demo shows how to build a kinematic controller.


const G = 600
const JUMP_FORCE = G * 0.38

var velocity = Vector2(0, 0);
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

var move_left = false
var move_right = false
var move_down = false
var up = false

var jump = false
var jumped = false

var animator
var animation = "Idle"

var to_ignore = null;

func _input(event):
	if not event.is_echo():

		if event.is_action_pressed("move_left"):
			move_left = true
			move_right = false
			get_node("sprite").set_flip_h(true)

		if event.is_action_pressed("move_right"):
			move_right = true
			move_left = false
			get_node("sprite").set_flip_h(false)

		if event.is_action_pressed("move_down"):
			move_down = true

		if event.is_action_pressed("jump"):
			jump = true
			
		if event.is_action_released("move_down"):
			move_down = false

		if event.is_action_released("move_left"):
			move_left = false

		if event.is_action_released("move_right"):
			move_right = false

		if event.is_action_released("jump"):
			jump = false

func _physics_process(delta):
	
	self.move_and_slide(velocity, Vector2(0, -1), 0, 2);
	var grounded = self.is_on_floor()

	if grounded:
		
		if jumped:
			jumped = false
	
	

			
		velocity.y = 1

		if to_ignore:
			remove_collision_exception_with(to_ignore)
			to_ignore = null

	elif velocity.y < G:
		velocity.y += G * delta

	else:
		velocity.y = G



	if move_right:
		velocity.x = 100
	elif move_left:
		velocity.x = -100
	else:
		velocity.x = 0


	if jump and grounded:
		
		jump = false
		jumped = true

		if move_down:
			to_ignore = move_and_collide(Vector2(0, 1))
			to_ignore = to_ignore.collider
			if to_ignore.get_name().match("ground*"):
				add_collision_exception_with(to_ignore)

		else:
			velocity.y -= JUMP_FORCE
		
		
		
		if move_left:
			velocity.x = -75
		elif move_right:
			velocity.x = 75

	if grounded:
		if abs(velocity.x) > 0:
			animation = "Run"
		else:
			animation = "Idle"
	else:
			animation = "Jump"
			



	if animator.get_current_animation() != animation:
		animator.play(animation)
	

	
func _ready():
	animator = self.get_node("AnimationPlayer")
	set_physics_process(true)
	set_process_input(true)
