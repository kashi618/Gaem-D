extends Control

signal clearPowerup
@onready var unlock_music: AudioStreamPlayer2D = $UnlockMusic

func _ready():
	$CanvasLayer.visible = false
	EventsBus.time_collected.connect(_on_time_powerup_collected)

func _on_timer_timeout():
	$AnimationPlayer.play_backwards("reveal")
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	emit_signal("clearPowerup")
	queue_free()

func _on_time_powerup_collected():
	print("collected")
	get_tree().paused = true
	$Timer.start()
	$CanvasLayer.visible = true
	$AnimationPlayer.play("reveal")
	$CanvasLayer/MarginContainer3/GPUParticles2D.emitting = true
	$CanvasLayer/MarginContainer5/MarginContainer4/GPUParticles2D2.emitting = true
	$CanvasLayer/MarginContainer6/MarginContainer4/GPUParticles2D2.emitting = true
	Global.has_time_powerup = true
	unlock_music.play()
