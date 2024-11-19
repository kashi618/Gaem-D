extends Node2D


func _on_area_2d_body_entered(body):
	if body is Player:
		print("end")
		
		await get_tree().create_timer(2).timeout
		
		EventsBus.go_next_map.emit()
