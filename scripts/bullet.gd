extends CharacterBody2D

@export var BULLET_SPEED = 500

var relativeSpeed : float
var direction : float
var spawnPos : Vector2
var spawnRot : float
var zDex : int

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zDex

func _physics_process(delta):
	velocity = Vector2(0, -(relativeSpeed + BULLET_SPEED)).rotated(direction)
	move_and_slide()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
