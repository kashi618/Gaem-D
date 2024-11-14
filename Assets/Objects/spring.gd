extends Node2D

@export var force = -700


func _ready():
	if Global.spring_disabled == true:
		self.visible = false

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player and (Global.spring_disabled == false):
		$Sprite2D/AnimationPlayer.play("Spring")
		area.get_parent().velocity.y = force
