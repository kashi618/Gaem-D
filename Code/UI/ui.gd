class_name UI
extends Control

signal no_more_time_v2

@onready var animation = $AnimationPlayer
@export var stopwatch_label: Label
@onready var stopwatch: stopwatch = $Stopwatch
@onready var one_min_song = $"1 minute song"
@onready var one_min_thirty_song = $"1 minute 30 second song"

func _ready():
	EventsBus.switch_scene.connect(transition)
	
	if Global.has_time_powerup == true:
		one_min_thirty_song.play()
		print("1 min thirty")
	else:
		one_min_song.play()
		print("1 min song")

func transition():
	animation.play("sceneTransition")
	await get_tree().create_timer(1).timeout
	animation.play_backwards("sceneTransition")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_stopwatch()
	

func update_stopwatch():
	stopwatch_label.text = stopwatch.time_to_string()


func _on_stopwatch_no_more_time():
	print("no more time signal received")
	emit_signal("no_more_time_v2")
