class_name Player
extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var wall_coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer

@export var double_jump: bool 
@export var wall_jump: bool 

# Constants for Tuning Movement
const SPEED = 300.0
const FALL_GRAVITY = 1000.0
const JUMP_POWER = -350.0
const MAXJUMPS = 1
const WALL_JUMP_POWER = 300.00


const ACCELERATION = 70.00
const DECELERATION = 20.00

# Initializing and Declaring Variables
# Basically just don't touch these
var numJumps = 0
var can_move = true


func _ready():
	EventsBus.PlayerDied.connect(_on_PlayerDied) # Signal connected once node is ready

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		if velocity.y < 0:
			velocity += get_gravity() * delta
		else:
			velocity += Vector2(0, FALL_GRAVITY) * delta
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
		
	# Allows input from user if they can move
	if can_move:
		# Gets input from user
		movement()    # Controls going left, right
		jump()  # Controls jump and double jump
		wallJump()    # Controls wall jump
	
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	# Allows movement of character
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	if was_on_wall and !is_on_wall() and !was_on_floor:
		wall_coyote_timer.start()

# Handle left and right movement
func movement():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	# Enhanced deceleration when falling
	elif !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

# Handles player jump
func jump():	
	# Jump!
	if can_jump():
		print("Jumped")
		numJumps += 1
		velocity.y = JUMP_POWER 
	   
	# Double jump!
	if Input.is_action_just_pressed("jump") and (numJumps < MAXJUMPS) and not is_on_floor() and double_jump:
		print("DoubleJumped")
		numJumps += 1
		velocity.y = JUMP_POWER+50
	
	if is_on_floor():
		numJumps = 0
		# pp

func can_jump() -> bool:
	return (is_on_floor() or (!coyote_timer.is_stopped() and velocity.y > 0)) and !jump_buffer_timer.is_stopped()

# Handles wall jump
func wallJump():
	# Direction of wall jump is in opposite direction of the wall
	var direction := Input.get_axis("left", "right")
	var direction_of_jump = -direction
	if can_wall_jump():
		# Player input is disabled to allow no interference with jump
		disable_movement(0.15)
		velocity.x = WALL_JUMP_POWER * direction_of_jump
		velocity.y = JUMP_POWER
		print("wall jumped")

func can_wall_jump() -> bool:
	return Input.is_action_just_pressed("jump") and (is_on_wall_only() or !wall_coyote_timer.is_stopped()) and wall_jump and coyote_timer.is_stopped()

# Function to disable movement for a certain amount of time
func disable_movement(time):
	can_move = false
	await get_tree().create_timer(time).timeout
	can_move = true

# Handle Player death
func _on_PlayerDied():
	
	can_move = false
	await get_tree().create_timer(1).timeout
	reset_player()
	print("player dieed")
	
func reset_player():
	global_position = Vector2(1937, -314)
	can_move = true
