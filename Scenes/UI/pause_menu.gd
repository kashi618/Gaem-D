extends Control


func _process(delta):
	testEsc()
	

func _ready():
	self.visible = false

func testEsc():
	if Input.is_action_just_pressed("esc") and (get_tree().paused == false):
		print("esc was pressed")
		self.visible = true
		pause()
	elif Input.is_action_just_pressed("esc") and (get_tree().paused == true):
		resume()

func pause():
	get_tree().paused = true


func resume():
	get_tree().paused = false
	self.visible = false

func _on_resume_pressed():
	get_tree().paused = false
	self.visible = false


func _on_settings_pressed():
	pass # Replace with function body.


func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")


func _on_retry_from_start_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
