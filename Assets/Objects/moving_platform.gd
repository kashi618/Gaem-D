extends AnimatableBody2D

@onready var x = Vector2(0, -300)


@export var move_up: bool
@export var move_speed: float
@export var initial_time: float
@export var time_before_reset: float
@onready var initial_timer: Timer = $InitialTimer
@onready var reset_timer: Timer = $ResetTimer

var platform = preload("res://Assets/Objects/moving_platform.tscn")
var move_direction = Vector2.DOWN
var player_on_platform: bool
var the_player: Player
var start_pos: Vector2
var move = false

func _ready():
	await get_parent().ready
	if move_up:
		move_direction = Vector2.UP
	reset_timer.wait_time = time_before_reset
	initial_timer.wait_time = initial_time
	initial_timer.start()
	start_pos = position
	
func _physics_process(delta: float) -> void:
	if !move:
		return
	position += move_direction * move_speed * delta

	if player_on_platform:
		the_player.position.y = position.y

func reset():
	move = false 
	position = start_pos
	await get_tree().create_timer(0.05).timeout
	reset_timer.start()
	move = true


func _on_initial_timer_timeout() -> void:
	move = true
	reset_timer.start()
