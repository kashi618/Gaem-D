extends Control

@onready var main: Node = $"../.."
var can_pause = true
var power_up_collecting = false

func _process(delta):
	testEsc()
	
func _ready():
	self.visible = false
	Dialogic.signal_event.connect(_on_dialogic)
	EventsBus.power_up_collected.connect(_on_power_up_collected)
	EventsBus.power_up_collected_finish.connect(_on_power_up_collected_finish)
func testEsc():
	if Input.is_action_just_pressed("esc") and (get_tree().paused == false) and can_pause:
		print("esc was pressed")
		self.visible = true
		pause()
	elif Input.is_action_just_pressed("esc") and (get_tree().paused == true) and can_pause and !power_up_collecting:
		resume()

func pause():
	get_tree().paused = true

func resume():
	get_tree().paused = false
	self.visible = false

func _on_resume_pressed():
	get_tree().paused = false
	self.visible = false

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")

func _on_retry_from_start_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_power_up_collected():
	power_up_collecting = true

func _on_power_up_collected_finish():
	power_up_collecting = false

func _on_dialogic(arg):
	if arg =="ConvoBegin":
		can_pause = false
	elif arg == "ConvoEnd":
		can_pause =  true  
	else:
		can_pause = true
