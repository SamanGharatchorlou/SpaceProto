extends Node

@onready var player = %Player
@onready var camera_2d = %Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func HandleMapBoundaries():
	var viewport_hsize_x : float = get_viewport().size.x * 0.5
	if player.position.x > camera_2d.position.x + viewport_hsize_x:
		player.position.x = camera_2d.position.x - viewport_hsize_x
	if player.position.x < camera_2d.position.x - viewport_hsize_x:
		player.position.x = camera_2d.position.x + viewport_hsize_x
		
	var viewport_hsize_y : float = get_viewport().size.y * 0.5
	if player.position.y > camera_2d.position.y + viewport_hsize_y:
		player.position.y = camera_2d.position.y - viewport_hsize_y
	if player.position.y < camera_2d.position.y - viewport_hsize_y:
		player.position.y = camera_2d.position.y + viewport_hsize_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
	HandleMapBoundaries()
		
		
