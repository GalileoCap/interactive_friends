extends Node

onready var MAIN = get_node('../')
onready var CLIENT = get_node('../client')
onready var DEBUG = get_node('../debug')

export (int) var PORT = 3000
export (int) var MAX_PLAYERS = 2

func _ready():
	get_tree().connect('network_peer_connected', self, 'player_entered')
	get_tree().connect('network_peer_disconnected', self, 'player_exited')

func start_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)
	
	DEBUG.logger(0, ['STARTED SERVER'])
	
	CLIENT.enter_room()

func player_entered(id): #U: Register player when they join
	MAIN.register_player(id)

func player_exited(id): #U: Delete player when they leave
	MAIN.unregister_player(id)
