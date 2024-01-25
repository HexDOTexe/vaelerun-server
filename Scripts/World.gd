extends Node
class_name World

@onready var test_map = preload("res://Scenes/Maps/Test/TestMap.tscn")

var world_map
var is_map_active : bool = false

func _ready():
	load_map()
	start_map()
	pass

func change_map():
	if is_map_active == false:
		return
	else:
		Server.print_log("server", "world", "Requested map change blocked.")

func load_map():
	world_map = test_map.instantiate()
	add_child(world_map)
	Server.print_log("server", "world", "Map has been loaded.")
	pass

func start_map():
	# eventually this will control entity activation signals for the loaded map
	Server.world_status = "ONLINE"
	is_map_active = true
	Server.print_log("server", "world", "Map has been started.")
	pass

func close_map():
	pass

func report_status():
	if is_map_active == true:
		Server.world_status = "ONLINE"
	pass
