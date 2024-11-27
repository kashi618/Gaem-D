extends Control

@onready var canvas = $CanvasLayer

func _ready():
	canvas.visible = false


func _on_retry_pressed():
	Global.timer_start = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_ui_no_more_time_v_2():
	print("Lose screen showing")
	get_tree().paused = true
	canvas.visible = true
