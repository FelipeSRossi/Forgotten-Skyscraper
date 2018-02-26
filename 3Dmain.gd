extends Node2D

# Member variables
var viewport = null
var viewport_sprite = null

# variables for the sprite animation


func _ready():
	viewport = get_node("Viewport")
	viewport_sprite = get_node("Viewport_Sprite")

	# Assign the sprite's texture to the viewport texture
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	# Let two frames pass to make sure the screen was captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	viewport_sprite.texture = viewport.get_texture()
  
	set_process(true)

