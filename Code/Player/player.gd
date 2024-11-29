class_name Player
extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var wall_coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var wall_jump_buffer_timer: Timer = $JumpBufferTimer
@onready var phantom_camera_host: PhantomCameraHost = $Player_Camera/PhantomCameraHost
@onready var death: AnimationPlayer = $death

@onready var jumpSFX = $JumpSFX
@onready var doubleJumpSFX = $DoubleJumpSFX

#@export var double_jump: bool 
#@export var wall_jump: bool 
@onready var jumper: GPUParticles2D = $Particles/Jump
@onready var x2jump: GPUParticles2D = $Particles/DoubleJump
@onready var runner: GPUParticles2D = $Particles/Running
@onready var animation_tree : AnimationTree = $AnimationTree

var head = preload("res://Assets/Characters/Head.png")
var current_map : Map
var start_pos : Vector2

@onready var canvas = $CanvasLayer
@onready var death_animation = $death

# Constants for Tuning Movement
@export var SPEED = 320
@export var JUMP_POWER = -350
@export var GRAVITY = 15
@export_range(0.0, 1.0) var friction = 0.28
@export_range(0.0 , 1.0) var acceleration = 0.06

const FALL_GRAVITY = 1100.0
const TERMINAL_VELOCITY = 500.0
const MAXJUMPS = 2
const WALL_JUMP_POWER = 300.00
#<<<<<<< HEAD
const PLAYER_DEATH_TIME = 0.5
#=======
const DOUBLE_JUMP_POWER = -280

#>>>>>>> Dev

# Initializing and Declaring Variables
# Basically just don't touch these
var numJumps = 0
var wall_jump_direction: float

func _ready():
	current_map = get_parent()
	canvas.visible = false
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
	#flipping player left and right based on left and right movement:
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
		velocity.y += GRAVITY
		if velocity.y > 0 and velocity.y < TERMINAL_VELOCITY:
			velocity.y *= 1.07
		else:
			velocity.y = velocity.y
		

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start()
	if Input.is_action_just_pressed("jump") and is_on_wall_only():
		wall_jump_buffer_timer.start()
		wall_jump_direction = -Input.get_axis("left", "right")
		
	# Allows input from user if they can move
	if Global.can_move:
		# Gets input from user
		movement()    # Controls going left, right
		jump()  # Controls jump and double jump
		wallJump(wall_jump_direction)    # Controls wall jump
	
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
	var dir = Input.get_axis("left", "right")
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * SPEED, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

# Handles player jump
func jump():	
	# Jump
	if can_jump():
		velocity.y = JUMP_POWER
		jumpSFX.pitch_scale = randf_range(0.8, 1.2)
		jumpSFX.play()
		#velocity.x = 200
		print("jump")
	   
	# Double jump!
	if Input.is_action_just_pressed("jump") and (numJumps < MAXJUMPS) and not is_on_floor() and Global.double_jump:
		numJumps += 1
		if numJumps < MAXJUMPS:
			print("doubleJump")
			doubleJumpSFX.pitch_scale = randf_range(0.8, 1.2)
			doubleJumpSFX.play()
			velocity.y = DOUBLE_JUMP_POWER
			x2jump.emitting = true
	
	if is_on_floor_only():
		numJumps = 0


func can_jump() -> bool:
	return (is_on_floor() or (!coyote_timer.is_stopped() and velocity.y > 0)) and !jump_buffer_timer.is_stopped()

# Handles wall jump
func wallJump(wall_jump_direction: float):
	# Direction of wall jump is in opposite direction of the wall
	if can_wall_jump():
		# Player input is disabled to allow no interference with jump
		disable_movement(0.15)
		velocity.x = WALL_JUMP_POWER * wall_jump_direction - 100
		velocity.y = JUMP_POWER
		print("wall jumped")

func can_wall_jump() -> bool:
	return !wall_jump_buffer_timer.is_stopped() and (is_on_wall_only() or !wall_coyote_timer.is_stopped()) and Global.wall_jump and coyote_timer.is_stopped()

# Function to disable movement for a certain amount of time
func disable_movement(time):
	Global.can_move = false
	await get_tree().create_timer(time).timeout
	Global.can_move = true

# Handle Player death
func _on_PlayerDied():
	velocity.x = 0
	velocity.y = 0
	canvas.visible = true
	Global.can_move = false
	death_animation.play("onDeath")
	await get_tree().create_timer(PLAYER_DEATH_TIME).timeout
	death_animation.play_backwards("onDeath")
	reset_player()
	await get_tree().create_timer(PLAYER_DEATH_TIME).timeout
	canvas.visible = false
	print("player dieed")
	
func reset_player():
	
	start_pos = current_map.start_pos
	global_position = start_pos
	await get_tree().create_timer(0.7).timeout
	Global.can_move = true

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
