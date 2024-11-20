class_name Player
extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var wall_coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer

@export var double_jump: bool 
@export var wall_jump: bool 
@onready var jumper: GPUParticles2D = $Particles/Jump
@onready var x2jump: GPUParticles2D = $Particles/DoubleJump
@onready var runner: GPUParticles2D = $Particles/Running
@onready var animation_tree : AnimationTree = $AnimationTree

var head = preload("res://Assets/Characters/Head.png")
var current_map : Map
var start_pos : Vector2
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
	
	current_map = get_parent()
	if not current_map.ready:
		await current_map.ready
	#start_pos = current_map.map_data.start_pos
	animation_tree.active = true
	EventsBus.PlayerDied.connect(_on_PlayerDied) # Signal connected once node is ready

var motion = Vector2()

func _process(delta):
	update_animation_parameters()
	
	if velocity == Vector2.ZERO:
		runner.emitting = true
	else:
		runner.emitting = false
	
	#if Input.is_action_pressed("right"):
		#runner.emitting = true
	#if Input.is_action_pressed("left"):
		#runner.emitting = true
	
	#flipping player left and right based on left and right movement:
	if true:
		if Input.is_action_just_pressed("left"):
			$Body/Head.flip_h = true
			$Body/Torso.flip_h = true
			$"Body/Right arm".flip_h = true
			$"Body/Left arm".flip_h = true
			$"Body/Right leg".flip_h = true
			$"Body/Left leg".flip_h = true
			runner.scale.x = 1
			
		
		if Input.is_action_just_pressed("right"):
			$Body/Head.flip_h = false
			$Body/Torso.flip_h = false
			$"Body/Right arm".flip_h = false
			$"Body/Left arm".flip_h = false
			$"Body/Right leg".flip_h = false
			$"Body/Left leg".flip_h = false
			runner.scale.x = -1
			

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
	
	#flipping player left and right based on left and right movement
	
		

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
		jumper.emitting = true
	   
	# Double jump!
	if Input.is_action_just_pressed("jump") and (numJumps < MAXJUMPS) and not is_on_floor() and double_jump:
		print("DoubleJumped")
		numJumps += 1
		velocity.y = JUMP_POWER+50
		x2jump.emitting = true
	
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
	start_pos = current_map.map_data.start_pos
	global_position = start_pos
	can_move = true

func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if Input.is_action_just_pressed("jump"):
		animation_tree["parameters/conditions/jump"] = true
	else:
		animation_tree["parameters/conditions/jump"] = false
