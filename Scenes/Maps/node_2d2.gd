extends Node2D


func _on_area_2d_body_exited(body):
	get_tree().change_scene_to_file("res://Scenes/Maps/flag_secret.tscn")
