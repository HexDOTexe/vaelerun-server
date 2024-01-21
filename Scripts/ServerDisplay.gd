extends Control

@onready var status_label = $ServerStatus

var refresh_rate = 2.0
var refresh_ready = true

func update_status_display():
	if refresh_ready == true:
		refresh_ready = false
		status_label.text = ""
		status_label.text += "Boot: " + Server.boot_status + "\n"
		status_label.text += "World: " + Server.world_status + "\n"
		status_label.text += "\n"
		status_label.text += "Connections: " + str(Server.connected_clients_count) + "\n"
		for i in Server.connected_clients:
			status_label.text += "Client: " + str(Server.connected_clients[i].ID) + "/" + str(Server.connected_clients[i].Name) +  "\n"
		await get_tree().create_timer(refresh_rate).timeout
		refresh_ready = true
	else:
		return
