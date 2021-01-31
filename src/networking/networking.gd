extends Node

onready var MAIN = get_node('../')
onready var DEBUG = get_node('../debug')
onready var LOBBY = get_node('../lobby')

func _ready():
	get_tree().connect('network_peer_connected', self, 'player_entered')
	get_tree().connect('network_peer_disconnected', self, 'player_exited')
	get_tree().connect('connected_to_server', self, 'enter_room')

func start_server(port, max_players):
	var host = NetworkedMultiplayerENet.new()
	host.create_server(int(port), int(max_players))
	get_tree().set_network_peer(host)
	
	DEBUG.logger(0, ['Started server on port', port, 'with', max_players, 'max players'])
	
	enter_room()

func player_entered(id): #U: Register player when they join
	MAIN.register_player(id)

func player_exited(id): #U: Delete player when they leave
	MAIN.unregister_player(id)

func join_server(ip, port):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, int(port))
	get_tree().set_network_peer(host)

func enter_room():
	var id = get_tree().get_network_unique_id()
	MAIN.register_player(id)
	DEBUG.logger(0, ['Joined room'])
	LOBBY.joined()
