extends Node2D

signal collected

func _ready():
	$AnimationPlayer.play("idle")

func _on_area_2d_body_entered(body):
	if body is Player:
		print("entered")
		EventsBus.time_collected.emit()
		EventsBus.power_up_collected.emit()

func _on_powerup_unlock_clear_powerup():
	EventsBus.power_up_collected_finish.emit()
	queue_free()
