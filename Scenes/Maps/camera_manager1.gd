extends Node

@export var player: CharacterBody2D
#@onready var oldDude = $"../OldGuy"

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

func _ready():
	Dialogic.signal_event.connect(DialogicSignal)

func _input(event):
	if Input.is_action_just_pressed("e"):
		$"../E".visible = false
		if is_active_interaction:
			
			is_active_interaction = false
			update_camera()
		else:
			find_interaction()


func run_dialogue(dialogue):
	var layout = Dialogic.start(dialogue)
	layout.register_character(load("res://Assets/Characters/Old dude/Old Dude.dch"), %SpeechPos)

signal collected

func DialogicSignal(arg: String):
	if arg == "ConvoEnd":
		if is_active_interaction:
			is_active_interaction = false
			update_camera()
	if arg == "doubleJumpPickedUp":
		emit_signal("collected")



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
					active_interaction = found_interaction_area
					if Global.isFirstEncounter == true:
						run_dialogue("First Encounter")
						Global.isFirstEncounter = false
					elif Global.isFirstEncounter == false and (Global.hasPowerup == true):
						Global.hasPowerup = false
						run_dialogue("PowerupEncounter")
					else:
						run_dialogue("randomConvo")
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
		

func update_current_zone(body, zone_a, zone_b):
	if body == player:
		match current_camera_zone:
			zone_a:
				current_camera_zone = zone_b
			zone_b:
				current_camera_zone = zone_a
		update_camera()


func _on_zone_01_body_entered(body):
	update_current_zone(body,0,1)

func _on_zone_12_body_entered(body):
	update_current_zone(body,1,2)
	
#func _on_zone_23_body_entered(body):
	#update_current_zone(body,2,3)
#
#func _on_zone_34_body_entered(body):
	#update_current_zone(body,2,4)
#
#
#func _on_zone_45_body_entered(body):
	#update_current_zone(body,2,4)
#
#
#func _on_zone_16_body_entered(body):
	#update_current_zone(body,1,6)
