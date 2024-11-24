extends CharacterBody2D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	animation.play("idle")
	
