extends CharacterBody2D

@onready var bullet_spawner = %BulletSpawner
@onready var projectile = load("res://scenes/projectile.tscn")
@onready var cooldown_timer = $Timer

const ACCELERATION : float = 350.0
const ROTATION_SPEED : float = 4
const MAX_SPD : float = 500

var force : Vector2

func PRNIT_VECTOR(label : String, vector : Vector2):
	print("label " + str(vector.x) + ", " + str(vector.y))

func Shoot():
	var instance = projectile.instantiate()
	instance.direction = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	instance.relativeSpeed = velocity.length()
	bullet_spawner.add_child(instance)
	
func _process(delta):
	if cooldown_timer.time_left <= 0:
		if Input.is_action_just_pressed("shoot") || Input.is_action_pressed("shoot"):
			Shoot()
			cooldown_timer.stop()
			cooldown_timer.start()
			cooldown_timer.wait_time = 1
			

func _physics_process(delta):

	var delta_accel = ACCELERATION * delta

	var direction_x = Input.get_axis("move_left", "move_right")
	if direction_x:
		rotation += direction_x * ROTATION_SPEED * delta
		
	# apply force in the movement direction
	var direction_y = Input.get_axis("move_up", "move_down")
	if direction_y < 0:
		var force_magnitude : Vector2 = -Vector2.UP.rotated(rotation) * direction_y * delta_accel
		force = force_magnitude
		
		# trying to move in the opposite direction
		if((force.x > 0 && velocity.x < 0) || (force.x < 0 && velocity.x > 0) ):
			force.x += force_magnitude.x * 2
		if((force.y > 0 && velocity.y < 0) || (force.y < 0 && velocity.y > 0) ):
			force.y += force_magnitude.y * 2
			
		# get the angle difference between the force direction and the x for example if we're pointing
		# up but still moving in the x at an angle >40 degree's slow down since that not the 'intended' movement direction
		var turn_deceleration : float = delta_accel * 0.1
		var turn_drag_angle : float = 3
		var y_over_x_ratio : float = force_magnitude.y * force_magnitude.y / force_magnitude.x * force_magnitude.x
		if y_over_x_ratio > turn_drag_angle:
			velocity.x = move_toward(velocity.x, 0, turn_deceleration)
		elif y_over_x_ratio < 1/turn_drag_angle:
			velocity.y = move_toward(velocity.y, 0, turn_deceleration)
			
	else:
		force = Vector2(0,0)

	# deceleration when there's no force is fast
	if force.is_zero_approx():
		velocity.y = move_toward(velocity.y, 0, delta_accel * 3)
		velocity.x = move_toward(velocity.x, 0, delta_accel * 3)

	velocity += force
	
	velocity.x = clamp(velocity.x, -MAX_SPD, MAX_SPD )
	velocity.y = clamp(velocity.y, -MAX_SPD, MAX_SPD )

	move_and_slide()
