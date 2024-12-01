extends Node

@export var Maps: Array[MapData]

@onready var current_map: Node2D = $current_map
var Map_ID = 1
func _ready():
	EventsBus.go_next_map.connect(_on_go_next_map)
	MapManager.main_scene = current_map
	MapManager.maps = Maps
	
	MapManager.load_map(Map_ID)
	
	Map_ID +=1
	await get_tree().create_timer(1).timeout

func _on_go_next_map():
	MapManager.load_map(Map_ID)
	
	Map_ID +=1
