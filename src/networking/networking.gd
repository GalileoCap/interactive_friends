extends Node

var Lobby

func _ready():
#	get_tree().connect('network_peer_connected', self, 'player_entered')
#	get_tree().connect('network_peer_disconnected', self, 'player_exited')
	get_tree().connect('connected_to_server', self, 'enter_room')

func start_server(port, max_players): 
	var host = NetworkedMultiplayerENet.new()
	host.create_server(int(port), int(max_players))
	get_tree().set_network_peer(host)
	
	Debug.logger(0, ['Started server on port %s with %s max players' % [port, max_players]])
	
	enter_room()

func join_server(ip, port):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, int(port))
	get_tree().set_network_peer(host)

func enter_room():
	Data.rpc_id(1, 'update_player', Data.me)
	Lobby.joined()
	
	Debug.logger(0, ['Joined room'])
