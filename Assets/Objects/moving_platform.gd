extends CharacterBody2D

@onready var x = Vector2(0, -300)
@export var start_pos: Vector2: set = _set_start_pos
@export var move: bool
var platform = preload("res://Assets/Objects/moving_platform.tscn")

#func ready():
	#var x = Vector2(position.x, position.y)
	#var y = "hello"
	#print(x)
	#print(y)

func _physics_process(delta: float) -> void:
	if !move:
		return
	 
	position.y += 100
	move_and_slide()
	
#func _process(delta):
	#
	#print(x)

func reset():
	self.queue_free()



func inst(pos):
	var instance = platform.instantiate()
	instance.position = pos
	add_child(instance)

#func _process(delta):
	#position.y +=200 * delta


func _on_area_2d_area_entered(area):
	inst(x)
	
func _set_start_pos(value: Vector2):
	start_pos = value
