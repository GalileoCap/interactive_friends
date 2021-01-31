extends Node

onready var MAIN = get_node('../')
onready var DEBUG = get_node('../debug')

func _ready():
	get_tree().connect('connected_to_server', self, 'enter_room')

func join_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_client('127.0.0.1', 3000)
	get_tree().set_network_peer(host)

func enter_room():
	var id = get_tree().get_network_unique_id()
	MAIN.register_player(id)
	
	DEBUG.logger(0, 'JOINED SERVER')
