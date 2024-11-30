extends Control

signal clearPowerup
@onready var canvas = $CanvasLayer
@onready var animation = $AnimationPlayer
@onready var timer = $Timer
@onready var particleLeft = %particleLeft
@onready var particleMiddle = %particleMiddle
@onready var particleRight = %particleRight
@onready var unlock_music: AudioStreamPlayer2D = $UnlockMusic

func _ready():
	canvas.visible = false


func _on_timer_timeout():
	animation.play_backwards("reveal")
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	emit_signal("clearPowerup")
	queue_free()


func _on_x_2_jump_powerup_collected():
	pass

func _on_camera_manager_collected():
	get_tree().paused = true
	timer.start()
	canvas.visible = true
	animation.play("reveal")
	particleLeft.emitting = true
	particleMiddle.emitting = true
	particleRight.emitting = true
	Global.wall_jump = true
	unlock_music.play()
