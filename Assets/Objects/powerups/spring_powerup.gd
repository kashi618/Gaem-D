extends Node2D

@onready var animation = $AnimationPlayer
signal collected

func _on_area_2d_body_entered(body):
	if body is Player:
		emit_signal("collected")
		EventsBus.power_up_collected.emit()

func _ready():
	animation.play("idle")

func _on_powerup_unlock_clear_powerup():
	EventsBus.power_up_collected_finish.emit()
	queue_free()
