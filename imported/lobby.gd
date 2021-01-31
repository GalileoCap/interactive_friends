extends Node

var player_info = {} #U: Player info, associate ID to data
var players_in = 0

var my_info = { name = 'P1', turn = 0 } #Info we send to other players

func _ready():
	#A: Connect all functions
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_ok')
	get_tree().connect('connection_failed', self, '_connected_fail')
	get_tree().connect('server_disconnected', self, '_server_disconnected')
	
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(3000, 2)
	get_tree().network_peer = peer

func _player_connected(id): #U: Send my info to both clients and server
	rpc_id(id, 'register_player', my_info)

func _player_disconnected(id): #U: Erase player from info
	player_info.erase(id)

func _connected_ok(): #U: Notify client that it succesfully connected
	#TODO
	print('Ok')
	pass
	
func _connected_fail(): #U: Notify client that it couldn't connect
	#TODO
	print('Fail')
	pass

func _server_disconnected(): #U: Notify client it's been kicked
	#TODO
	pass

remote func register_player(info): #U: Register a player's info on connect
	var id = get_tree().get_rpc_sender_id() #A: Get the id of the RPC sender.
	
	info.turn = players_in
	players_in += 1
	
	player_info[id] = info
	
	#TODO: Update lobby UI

func load_player(p):
	var player = preload('res://src/player.tscn').instance()
	player.set_name(str(p))
	player.set_network_master(p)
	player.my_info = player_info[p]
	add_child(player)
	get_node(str(p)).set_player()

func load_players(): #U: Loads all players
	#Load my player
	var selfPeerID = get_tree().get_network_unique_id()
	load_player(selfPeerID)

	#Load other players
	for p in player_info:
		load_player(p)

remote func pre_configure_game(): #U: Loads the game for this player
	# Load world
	#var world = load(which_level).instance()
	#get_node('/root').add_child(world)
	
	load_players()
	
	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring.
	# The server can call get_tree().get_rpc_sender_id() to find out who said they were done.
	rpc_id(1, 'done_preconfiguring')

var players_done = []
remote func done_preconfiguring(): #U: Keeps track of which players are done loading
	var who = get_tree().get_rpc_sender_id()
	players_done.append(who)

func join():
	var id = get_tree().get_network_unique_id()
	var info = { name = 'P2', turn = players_in}

	players_in += 1
	player_info[id] = info

	print(player_info)
	pre_configure_game()
#	var peer = NetworkedMultiplayerENet.new()
#	peer.create_client('127.0.0.1', 3000)
#	get_tree().network_peer = peer
