class_name Player
extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer

@export var double_jump: bool 
@export var wall_jump: bool 
const SPEED = 300.0
const JUMP_POWER = -350.0
const WALL_JUMP_POWER = 300.00
const MAXJUMPS = 1
const ACCELERATION = 70.00
const DECELERATION = 20.00
var numJumps = 0
var can_move = true

func _ready():
	EventsBus.PlayerDied.connect(_on_PlayerDied)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Gets input from user
	if can_move:
		movement() # Controls going left, right
		doubleJump() # Controls jump and double jump
		wallJump()
	
	var was_on_floor = is_on_floor()
	# Allows movement of character
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()

func movement():
	# Moves player left and right
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION)
	elif !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
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

func wallJump():
	var direction := Input.get_axis("left", "right")
	var direction_of_jump = -direction
	if Input.is_action_just_pressed("jump") and is_on_wall_only() and wall_jump:
		disable_movement(0.15)
		velocity.x = WALL_JUMP_POWER * direction_of_jump
		velocity.y = JUMP_POWER
		
func disable_movement(time):
	can_move = false
	await get_tree().create_timer(time).timeout
	can_move = true
	
func _on_PlayerDied():
	print("player dieed")
