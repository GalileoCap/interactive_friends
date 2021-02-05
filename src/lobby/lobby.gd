extends Control

func _ready():
	show()
	$join.show()
	$host.show()
	$chatroom.hide()

func join_server():
	var ip = $join/ip_input.text
	var port = $join/port_input.text
	
	NET.join_server(ip, int(port))

func host_server():
	var port = $host/port_input.text
	var max_players = $host/max_players_input.text
	
	NET.start_server(int(port), int(max_players))

func joined(): #U: 
	$join.hide()
	$host.hide()
	$chatroom.show()
	$chatroom.send_message('joined') #A: Announces it in the chat
