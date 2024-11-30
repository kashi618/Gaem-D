extends Node2D


func _on_area_2d_body_entered(body):
	if body is Player:
		print("end")
		EventsBus.switch_scene.emit()
		await get_tree().create_timer(1).timeout
		
		EventsBus.go_next_map.emit()
		
