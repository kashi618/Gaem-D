extends CharacterBody2D

const SPEED = 300.0
const JUMP_POWER = -350.0
const MAXJUMPS = 2


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Gets input from user
	movement() # Controls going left, right
	doubleJump() # Controls jump and double jump
	
	# Allows movement of character
	move_and_slide()

func movement():
	# Moves player left and right
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func doubleJump():
	var numJumps = 0
	
	# Jump!
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print("Jumped")
		numJumps += 1
		velocity.y = JUMP_POWER
	
	if Input.is_action_just_pressed("jump") and (numJumps < MAXJUMPS) and not is_on_floor():
		print("DoubleJumped")
		velocity.y = JUMP_POWER+50
	
	if is_on_floor():
		numJumps = 0
