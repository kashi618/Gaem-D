class_name UI
extends Control

signal no_more_time_v2

@export var stopwatch_label: Label
var stopwatch: stopwatch
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("stopwatch")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_stopwatch()

func update_stopwatch():
	stopwatch_label.text = stopwatch.time_to_string()


func _on_stopwatch_no_more_time():
	print("no more time signal received")
	emit_signal("no_more_time_v2")
