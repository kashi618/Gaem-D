extends Node

var maps: Array[MapData]

var main_scene: Node2D = null
var loaded_map: Map = null

func unload_map() -> void:
	if is_instance_valid(loaded_map):
		loaded_map.queue_free()
		
	loaded_map = null
		
func load_map(map_ID: int) -> void:
	
	unload_map()
	
	var map_data = get_map_data_by_ID(map_ID)
	print("Loading Map: %s" % map_data.map_name)
	if not map_data:
		return
	
	var map_path = "res://Scenes/%s.tscn" % map_data.map_path
	var map_res := load(map_path)
	
	if map_res:
		loaded_map = map_res.instantiate()
	
		main_scene.add_child(loaded_map)
	else:
		print("map doesn't exist")
	
func get_map_data_by_ID(ID: int) -> MapData:
	var map_to_return: MapData = null
	
	for map : MapData in maps:
		if map.map_ID == ID:
			map_to_return = map
	
	return map_to_return
