extends Node

func _ready():
	EventsBus.time_collected.connect(_on_time_collected)
##for testing powerups:
var wall_jump = true
var double_jump = true
#var hasWallPowerup = true
var spring_disabled = false
#var isFirstEncounter = false
#var additional_time = 3
var firstPlay = false
var firstLost = false
#var can_move = true
#var has_time_powerup = true
#var has_time_powerup_2 = true
#var has_time_powerup_3 = true
#var firstLost_checker = false

##for normal settings:
#var wall_jump = false
#var double_jump = false
var hasWallPowerup = false
#var spring_disabled = true
var isFirstEncounter = true
var additional_time = 0
#var firstPlay = true
#var firstLost = false
var can_move = true
var has_time_powerup = false
var has_time_powerup_2 = false
var has_time_powerup_3 = false
var firstLost_checker = false

#Applies to entire game
var timer_start = false

func _on_time_collected():
	if additional_time >= 3:
		return
	additional_time += 1
	
