extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var area = $Area2D

var inObject = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("down") and (inObject==1):
		collision.set_deferred("disabled",true)
		print("Fall through platform")
		


func _on_area_2d_area_exited(area: Area2D) -> void:
	collision.set_deferred("disabled",false)
	inObject = 0


func _on_area_2d_area_entered(area: Area2D) -> void:
	inObject = 1
	
	
