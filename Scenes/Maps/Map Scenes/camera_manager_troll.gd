extends Node

@export var player: CharacterBody2D
@onready var oldDude = $"../OldGuy"
@onready var speechBubblePos = $"../SpeechPos"
@onready var e = $"../E"

@export var CameraZone0: PhantomCamera2D
@export var CameraZone1: PhantomCamera2D
@export var CameraZone2: PhantomCamera2D
@export var CameraZone3: PhantomCamera2D
@export var CameraZone4: PhantomCamera2D
@export var CameraZone5: PhantomCamera2D

@export var Interaction_Area1: Area2D
@export var Interaction_Camera1: PhantomCamera2D

var current_camera_zone: int = 0

var is_active_interaction: bool = false
var active_interaction: Area2D 
var inDialogue = false


func _ready():
	var inDialogue = false
	Dialogic.signal_event.connect(DialogicSignal)
	#if Global.firstPlay == true:
		#Dialogic.start("GameBegin")
	#elif Global.firstLost == true:
		#Dialogic.start("first_lose")
	#else:
		#Global.timer_start = true


func _input(event):
	if Input.is_action_just_pressed("e"):
		if inDialogue == false:
			e.visible = false
			if is_active_interaction:
				is_active_interaction = false
				update_camera()
			else:
				find_interaction()
		else:
			return

func run_dialogue(dialogue):
	var layout = Dialogic.start(dialogue)
	layout.register_character(load("res://Assets/Characters/Old dude/Old Dude.dch"), speechBubblePos)

signal collected

func DialogicSignal(arg: String):
	if arg == "TimeStop":
		Global.timer_start = false
	if arg == "TimeContinue":
		Global.timer_start = true
	if arg == "ReturnToEnd":
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	if arg == "ConvoBegin":
		print("yooo")
		Global.can_move = false
		inDialogue = true
	if arg == "ConvoEnd":
		inDialogue = false
		if is_active_interaction:
			is_active_interaction = false
			Global.can_move = true
			update_camera()
	if arg == "doubleJumpPickedUp":
		emit_signal("collected")
	if arg == "GameStartOnce":
		Global.can_move = true
		Global.firstPlay = false
		Global.timer_start = true
	if arg == "ConvoLoseEnd":
		Global.can_move = true
		Global.timer_start = true
		Global.firstLost = false



func find_interaction():
	var areas: Array = [Interaction_Area1]
	var found_interaction_area: Area2D
	
	for area in areas:
		if found_interaction_area == null:
			var overlapping_bodies = area.get_overlapping_bodies()
			for i in overlapping_bodies:
				if i == player:
					found_interaction_area = area
					is_active_interaction = true
					Global.can_move = false
					active_interaction = found_interaction_area
					run_dialogue("troll")
					#Dialogic.signal_event.connect(DialogicSignal)
					update_camera()

func update_camera():
	var cameras = [CameraZone0, CameraZone1, CameraZone2, CameraZone3, CameraZone4, CameraZone5]
	for camera in cameras:
		if camera != null:
			camera.priority = 0
	
	if is_active_interaction:
		match active_interaction:
			Interaction_Area1:
				Interaction_Camera1.priority = 1
	else:
		match current_camera_zone:
			0:
				CameraZone0.priority = 1
			1:
				CameraZone1.priority = 1
			2:
				CameraZone2.priority = 1
			3:
				CameraZone3.priority = 1
			4:
				CameraZone4.priority = 1
			5:
				CameraZone5.priority = 1
		

func update_current_zone(body, zone):
	if body == player:
		current_camera_zone = zone
		update_camera()


func _on_zone_0_body_entered(body):
	update_current_zone(body,0)


func _on_zone_spring_spikes_body_entered(body):
	update_current_zone(body,1)


func _on_zone_floor_spikes_body_entered(body):
	update_current_zone(body,2)



func _on_death_zone_body_entered(body):
	if body ==player:
		await get_tree().create_timer(1).timeout
		current_camera_zone = 0
		var cameras = [CameraZone0, CameraZone1, CameraZone2, CameraZone3, CameraZone4, CameraZone5]
		for camera in cameras:
			if camera != null:
				camera.priority = 0
		CameraZone0.priority = 1


func _on_interaction_area_body_entered(body):
	e.visible = true

func _on_interaction_area_body_exited(body):
	e.visible = false


func _on_zone_flag_body_entered(body):
	update_current_zone(body,3)
