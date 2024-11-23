extends Node2D

@onready var animation = $AnimationPlayer
signal collected

func _on_area_2d_body_entered(body):
	emit_signal("collected")

func _ready():
	animation.play("idle")


func _on_powerup_unlock_clear_powerup():
	queue_free()
