extends Area2D

# Detects when player enters body
func _on_body_entered(body: Node2D) -> void:
	print("Player Died")
	EventsBus.PlayerDied.emit()
