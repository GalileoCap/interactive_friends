extends Node

var Lobby
var Map

#TODO:
#set_refuse_new_network_connections(value) # Refuse new players
#get_tree().connect('connected_to_server', self, 'enter_room')

func _ready():
	pass
#	get_tree().connect('network_peer_connected', self, 'peer_connected')
#	get_tree().connect('network_peer_disconnected', self, 'peer_disconnected')
#	get_tree().connter('connection_failed', self, 'failed')

	#TODO: Reset Lobby
#	get_tree().connter('server_disconnected', self, 'server_disconnected')

#U: Starts a server
func start_server(port, max_players):
	var host = NetworkedMultiplayerENet.new()
	host.create_server(port, max_players)
	get_tree().set_network_peer(host)
	
	Debug.logger(0, ['Started server on port %s with %s max players' % [port, max_players]])
	
	get_tree().emit_signal('connected_to_server') #A: The host enters the room

#U: Joins a server
func join_server(ip, port):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, port)
	get_tree().set_network_peer(host)
