extends Node

var network = ENetMultiplayerPeer.new()
var address : String = "127.0.0.1"
var port = 9999
var max_players = 100

@onready var status_label = $/root/Server/ServerStatus
var boot_status = "OFFLINE"
var world_status = "OFFLINE"

var connected_clients_count = 0
var connected_clients = {}

#region Server Boot
func _ready():
	start_server()

func start_server():
	print_log("server", "Starting boot.")
	var error = network.create_server(port, max_players)
	
	network.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(network)
	
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if error != OK:
		print_log("server", "ERROR: Could not start network service.")
		boot_status = "ERROR"
		return
	else:
		print_log("server", "Listening for connections.")
		boot_status = "OK"
	
	update_status_display()

func update_status_display():
	status_label.text = ""
	status_label.text += "Boot: " + boot_status + "\n"
	status_label.text += "World: " + world_status + "\n"
	status_label.text += "\n"
	status_label.text += "Connections: " + str(connected_clients_count) + "\n"
	for i in connected_clients:
		status_label.text += "Client: " + str(connected_clients[i].ID) + "/" + str(connected_clients[i].Name) +  "\n"

func print_log(type, content):
	# type = server, network, world,
	var system_time : String = Time.get_datetime_string_from_system()
	print("["+system_time+"]" + "["+type.to_upper()+"]" + ":" + content)
#endregion

#region Network Events
func player_connected(client_id):
	print_log("network","Client " + str(client_id) + " connected.")
	connected_clients_count += 1
	update_status_display()

func player_disconnected(client_id):
	print_log("network","Client " + str(client_id) + " disconnected.")
	connected_clients_count -= 1
	connected_clients.erase(client_id)
	update_status_display()
	#var players = get_tree().get_nodes_in_group("Player")
	#for i in players:
	#	if i.name == str(client_id):
	#		i.queue_free()

func connected_to_server(client_id):
	pass

func connection_failed(client_id):
	pass

@rpc("any_peer")
func sync_client_information(player, client_id):
	if !connected_clients.has(client_id):
		connected_clients[client_id] ={
			"Name" : player,
			"ID" : client_id
		}
	update_status_display()
#endregion

#region Game World Events
func process(delta):
	pass

@rpc("any_peer")
func spawn_player_node(client_id : int, character_name: String):
	print_log("world", "Spawning new player node @: ")
	# Code To Spawn Player Node
#endregion







#@rpc("any_peer", "call_local") 
#func fetch_skill_damage(player_ID, skill_ID, requestor):
#	var damage = DataImport.skill_data[skill_ID].skill_damage_value
#	rpc_id(player_ID, "return_skill_damage", damage, requestor)
#	print("sending msg: skill damage" + str(damage))

#@rpc("call_remote")
#func return_skill_damage(client_id, damage, requestor):
#	pass
