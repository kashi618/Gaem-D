extends Area2D

signal resetCamera
# Detects when player enters body
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Player Died")
		EventsBus.PlayerDied.emit()
		emit_signal("resetCamera")
