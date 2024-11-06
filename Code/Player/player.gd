class_name Player
extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer

@export var double_jump: bool 
const SPEED = 300.0
const JUMP_POWER = -350.0
const MAXJUMPS = 1
var numJumps = 0


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Gets input from user
	movement() # Controls going left, right
	doubleJump() # Controls jump and double jump
	
	var was_on_floor = is_on_floor()
	# Allows movement of character
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()

func movement():
	# Moves player left and right
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func doubleJump():
	
	# Jump!
	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_timer.is_stopped()):
		print("Jumped")
		numJumps += 1
		velocity.y = JUMP_POWER    
	
	if Input.is_action_just_pressed("jump") and (numJumps < MAXJUMPS) and not is_on_floor() and double_jump:
		print("DoubleJumped")
		numJumps += 1
		velocity.y = JUMP_POWER+50
	
	if is_on_floor():
		numJumps = 0
		# pp
		
