extends Control

func _ready():
	var _tmp = get_tree().connect('connected_to_server', self, 'enter_server')
	
	show()
	$join.show()
	$host.show()
	$chatroom.hide()

func join_server():
	var ip = $join/ip_input.text
	var port = $join/port_input.text
	
	NET.join_server(ip, int(port))

func host_server():
	var port = int($host/port_input.text)
	var _max_players = int($host/max_players_input.text)-1 #Taking into account the host
	
	NET.start_server(port, 8) #TODO: int(max_players))

func enter_server(): 
	$join.hide()
	$host.hide()
	$chatroom.show()
