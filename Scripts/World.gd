extends Node
class_name World

@onready var test_map = preload("res://Scenes/Maps/Test/TestMap.tscn")

var is_map_active : bool = false
var world_map
var world_state

func _ready():
	load_map()
	start_map()
	pass

func _physics_process(delta):
	process_world_state()
	pass

func change_map():
	if is_map_active == false:
		return
	else:
		Server.print_log("server", "world", "Requested map change blocked.")

func load_map():
	world_map = test_map.instantiate()
	world_map.name = "Map"
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

func process_world_state():
	if !Server.player_states_collection.is_empty():
		world_state = Server.player_states_collection.duplicate(true)
		for player in world_state.keys():
			world_state[player].erase("T")
		world_state["T"] = Time.get_unix_time_from_system()
		# Do A Bunch Of Things Here
		Server.send_world_state(world_state)
