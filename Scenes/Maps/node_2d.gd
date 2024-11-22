extends Node2D


func _on_area_2d_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://Scenes/Maps/tree_secret.tscn")
