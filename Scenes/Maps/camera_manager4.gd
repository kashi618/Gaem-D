extends Node

@export var player: CharacterBody2D

@export var CameraZone0: PhantomCamera2D
@export var CameraZone1: PhantomCamera2D
@export var CameraZone2: PhantomCamera2D
@export var CameraZone3: PhantomCamera2D
@export var CameraZone4: PhantomCamera2D
@export var CameraZone5: PhantomCamera2D

var current_camera_zone: int = 0

func update_camera():
	var cameras = [CameraZone0, CameraZone1, CameraZone2, CameraZone3, CameraZone4, CameraZone5]
	for camera in cameras:
		if camera != null:
			camera.priority = 0
	
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


func _on_zone_01_body_entered(body):
	update_current_zone(body, 1)

func _on_zone_12_body_entered(body):
	update_current_zone(body, 2)
	
func _on_zone_23_body_entered(body):
	update_current_zone(body, 3)

func _on_zone_34_body_entered(body):
	update_current_zone(body, 4)


func _on_zone_45_body_entered(body):
	update_current_zone(body, 4)

func _on_zone_16_body_entered(body):
	update_current_zone(body, 6)




func _on_death_zone_body_entered(body):
	if body ==player:
		await get_tree().create_timer(1).timeout
		current_camera_zone = 0
		var cameras = [CameraZone0, CameraZone1, CameraZone2, CameraZone3, CameraZone4, CameraZone5]
		for camera in cameras:
			if camera != null:
				camera.priority = 0
		CameraZone0.priority = 1
