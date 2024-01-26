extends Node

var network = ENetMultiplayerPeer.new()
var address : String = "127.0.0.1"
var port = 9999
var max_players = 100

var boot_status = "OFFLINE"
var world_status = "OFFLINE"

var connected_clients = {}
var connected_clients_count = 0
var player_states_collection = {}

#region Server Boot
func _ready():
	start_server()

func start_server():
	print_log("server", "network", "Starting boot.")
	var error = network.create_server(port, max_players)
	network.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(network)
	
	multiplayer.peer_connected.connect(client_connected)
	multiplayer.peer_disconnected.connect(client_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if error != OK:
		print_log("server", "network", "ERROR: Could not start network service.")
		boot_status = "ERROR"
		return
	else:
		print_log("server", "network", "Listening for connections.")
		boot_status = "OK"

func print_log(source, type, content):
	# type = server, network, world,
	var system_time : String = Time.get_datetime_string_from_system()
	print("["+system_time+"]" + "["+source.to_upper()+"]" + "["+type.to_upper()+"]" + ":" + content)
#endregion

#region Network Events
func client_connected(client_id):
	print_log("client", "network", "Client " + str(client_id) + " connected.")
	connected_clients_count += 1
	spawn_player_node.rpc_id(0, client_id, 0)
	print_log("server", "world", "Spawning new player node for " + str(client_id))

func client_disconnected(client_id):
	print_log("client", "network", "Client " + str(client_id) + " disconnected.")
	connected_clients_count -= 1
	connected_clients.erase(client_id)
	player_states_collection.erase(client_id)
	despawn_player_node.rpc_id(0, client_id)
	#if has_node(str(client_id)):
	#	get_node(str(client_id)).queue_free()
	#	despawn_player_node.rpc_id(0, client_id)

func connected_to_server(_client_id):
	pass

func connection_failed(_client_id):
	pass

@rpc("any_peer")
func sync_client_information(client_id, player):
	if !connected_clients.has(client_id):
		connected_clients[client_id] ={
			"ID" : client_id,
			"Name" : player
		}
#endregion

#region Game World Events
func process(_delta):
	pass

@rpc("authority", "call_remote", "reliable")
func spawn_player_node(client_id : int, position):
	pass

@rpc("authority", "call_remote", "reliable")
func despawn_player_node(client_id : int):
	pass

func send_player_state(player_state):
	pass

@rpc("any_peer", "unreliable_ordered")
func receive_player_state(player_state):
	var id = multiplayer.get_remote_sender_id()
	if player_states_collection.has(id):
		if player_states_collection[id]["T"] < player_state["T"]:
			player_states_collection[id]  = player_state
			#print_log("client","world","Updating existing state: " + str(player_state))
	else:
		player_states_collection[id] = player_state
		print_log("client","world","Adding new state: " + str(player_state))

func send_world_state(world_state):
	receive_world_state.rpc_id(0, world_state)

@rpc("any_peer", "unreliable_ordered")
func receive_world_state(world_state):
	pass
#endregion



#@rpc("any_peer", "call_local") 
#func fetch_skill_damage(player_ID, skill_ID, requestor):
#	var damage = DataImport.skill_data[skill_ID].skill_damage_value
#	rpc_id(player_ID, "return_skill_damage", damage, requestor)
#	print("sending msg: skill damage" + str(damage))

#@rpc("call_remote")
#func return_skill_damage(client_id, damage, requestor):
#	pass
