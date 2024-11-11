class_name stopwatch
extends Node

var time = 0.0
var stopped = false

func _process(delta: float) -> void:
	if stopped:
		return
	
	time += delta

func reset():
	time = 0.0

#changes time to string
func time_to_string() -> String:
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time/60
	# gives 00:00:000 format
	var format_string = "%02d : %02d : %02d"
	
	var actual_string = format_string%[min, sec, msec]
	return actual_string
