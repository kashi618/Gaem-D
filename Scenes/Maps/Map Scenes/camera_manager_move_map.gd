extends Node

@export var player: CharacterBody2D

@export var CameraZone0: PhantomCamera2D
@export var CameraZone1: PhantomCamera2D
@export var CameraZone2: PhantomCamera2D
@export var CameraZone3: PhantomCamera2D
@export var CameraZone4: PhantomCamera2D
@export var CameraZone5: PhantomCamera2D

var current_camera_zone: int = 0
const CAMERA_RESET_TIME: int = 1
func _ready():
	#$"CameraNode/zone0-1/PhantomCamera2D".priority = 1
	EventsBus.PlayerDied.connect(_on_playerdied)

func update_camera():
	var cameras = [CameraZone0, CameraZone1, CameraZone2, CameraZone3, CameraZone4, CameraZone5]
	for camera in cameras:
		if camera != null:
			camera.priority = 0
			print("null: ", camera)
	
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

func get_current_camera_zone() -> int:
	return current_camera_zone

func update_current_zone(body, zone):
	if body == player:
		current_camera_zone = zone
		update_camera()


func _on_playerdied():
#	await get_tree().create_timer(CAMERA_RESET_TIME).timeout
#	update_current_zone(0, get_current_camera_zone())
	pass


func _on_death_zone_body_entered(body):
	if body == player:
		await get_tree().create_timer(0.8).timeout
		current_camera_zone = 0
		var cameras = [CameraZone0, CameraZone1, CameraZone2, CameraZone3, CameraZone4, CameraZone5]
		for camera in cameras:
			if camera != null:
				camera.priority = 0
		CameraZone0.priority = 1
		print("death_zone")


func _on_zone_1_body_entered(body):
	update_current_zone(body, 0)


func _on_zone_secret_body_entered(body):
	update_current_zone(body, 1)
