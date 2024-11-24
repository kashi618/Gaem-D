class_name Map
extends Node

@export var map_ID: int

var map_data : MapData

func _ready() -> void:
	map_data = MapManager.get_map_data_by_ID(map_ID)
	
