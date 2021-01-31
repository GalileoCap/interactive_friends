extends Node

onready var MAIN = get_node('../')
onready var DEBUG = get_node('../debug')

func _ready():
	get_tree().connect('network_peer_connected', self, 'player_entered')
	get_tree().connect('network_peer_disconnected', self, 'player_exited')
	get_tree().connect('connected_to_server', self, 'enter_room')

func start_server():
	var port = get_node('../lobby/host/port_input').text
	var max_players = get_node('../lobby/host/max_players_input').text
	
	var host = NetworkedMultiplayerENet.new()
	host.create_server(int(port), int(max_players))
	get_tree().set_network_peer(host)
	
	DEBUG.logger(0, ['Started server on port', port, 'with', max_players, 'max players'])
	
	enter_room()

func player_entered(id): #U: Register player when they join
	MAIN.register_player(id)

func player_exited(id): #U: Delete player when they leave
	MAIN.unregister_player(id)

func join_server():
	var ip = get_node('../lobby/join/ip_input').text
	var port = get_node('../lobby/join/port_input').text
	
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, int(port))
	get_tree().set_network_peer(host)

func enter_room():
	var id = get_tree().get_network_unique_id()
	MAIN.register_player(id)
	DEBUG.logger(0, ['Joined room'])
