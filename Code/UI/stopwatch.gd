class_name stopwatch
extends Node

var time = 8
var stopped = false

signal no_more_time



func _process(delta: float) -> void:
	if Global.timer_start == true:
		if time > 0:
			time -= delta
		else:
			if Global.firstLost_checker == true:
				Global.firstLost = true
				Global.firstLost_checker = false
			print("timer has stopped")
			emit_signal("no_more_time")
		if stopped:
			return

func reset():
	time = 60

#changes time to string
func time_to_string() -> String:
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time/60
	# gives 00:00:000 format
	var format_string = "%02d : %02d : %02d"
	
	var actual_string = format_string%[min, sec, msec]
	return actual_string
