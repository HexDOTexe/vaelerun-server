extends Control

@onready var status_label = $ServerStatus

var refresh_rate = 0.5
var refresh_ready = true

var tick_rate = Engine.get_physics_ticks_per_second()

func update_status_display():
	if refresh_ready == true:
		refresh_ready = false
		status_label.text = ""
		status_label.text += "Address: " + str(Server.address) + "\n"
		status_label.text += "Port: " + str(Server.port) + "\n"
		status_label.text += "\n"
		status_label.text += "Boot:  " + Server.boot_status + "\n"
		status_label.text += "World: " + Server.world_status + "\n"
		status_label.text += "World Tick Rate: "+str(tick_rate)+"/s"+"\n"
		#status_label.text += "Next Respawn Tick: " + str(World/SpawnTimer.time_left) +  "\n"
		status_label.text += "\n"
		status_label.text += "Connections: " + str(Server.connected_clients_count) + "\n"
		for i in Server.connected_clients:
			var id = str(Server.connected_clients[i].ID)
			var char_name = str(Server.connected_clients[i].Name)
			var pos = str(Server.player_states_collection[i]["P"])
			status_label.text += "Client: " + id + " / " + char_name + " @ " + pos +  "\n"
		await get_tree().create_timer(refresh_rate).timeout
		refresh_ready = true
	else:
		return
