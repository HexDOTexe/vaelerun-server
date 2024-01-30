extends Node
class_name World

@onready var test_map = preload("res://Scenes/Maps/Test/TestMap.tscn")

var is_map_active : bool = false
var world_map
var world_state

var entity_id_counter = 1
var entity_maximum = 2
var entity_types =["Slime"]
var entity_spawn_locations = [Vector2(300, 300), Vector2(400, 400)]
var open_entity_spawns = [0, 1]
var busy_entity_spawns = {}
var entity_list = {}

func _ready():
	load_map()
	start_map()

func _physics_process(delta):
	process_world_state()

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

func start_map():
	# eventually this will control entity activation signals for the loaded map
	var map_spawn_timer = Timer.new()
	map_spawn_timer.name = "SpawnTimer"
	map_spawn_timer.wait_time = 3
	map_spawn_timer.autostart = true
	map_spawn_timer.connect("timeout", spawn_or_despawn_entity)
	add_child(map_spawn_timer)
	Server.world_status = "ONLINE"
	is_map_active = true
	Server.print_log("server", "world", "Map has been started.")

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
		world_state["Entities"] =  entity_list
		# Do A Bunch Of Things Here
		Server.send_world_state(world_state)

func spawn_or_despawn_entity():
	# Has support for the following:
	# type: chosen randomly from the list of entity_types
	# spawn_location: chosen randomly from the list of entity_spawn_locations
	# (entity_spawn_locations will eventually be populated with EntitySpawns from the Map.)
	Server.print_log("server", "world", "Spawning new entity node")
	if entity_list.size() >= entity_maximum:
		pass
	else:
		# the 'spawn' part of this function
		randomize()
		var type = entity_types[randi() % entity_types.size()]
		var random_index = randi() % open_entity_spawns.size()
		var spawn_location = entity_spawn_locations[open_entity_spawns[random_index]]
		busy_entity_spawns[entity_id_counter] = open_entity_spawns[random_index]
		open_entity_spawns.remove_at(random_index)
		# eventually these definitions will be replaced with a database lookup instead of coded
		entity_list[entity_id_counter] = {
			"entity_type": type, 
			"entity_spawn_location": spawn_location,
			"entity_current_health": 500,
			"entity_maximum_Health": 500,
			"entity_state": "Idle",
			"entity_respawn_timer": 1
			}
		entity_id_counter += 1
		# the 'despawn' part of this function
		for entity in entity_list.keys():
			if entity_list[entity]["entity_state"] == "Dead":
				if entity_list[entity]["entity_respawn_timer"] == 0:
					entity_list.erase(entity)
				else:
					entity_list[entity]["entity_respawn_timer"] = entity_list[entity]["entity_respawn_timer"] - 1
