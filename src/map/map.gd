extends Node

#U: Keep track of each room's position
puppet var map = [[0, 0, 0], [0, 0, 0], [0, 0, 0]] #TODO: Make resizable
#e.g: Only
#[
#	[0, 0, 0],
#	[0, 1, 0],
#	[0, 0, 0]
#]
#e.g: A few players joined
#[
#	[   0, 21351, 9913],
#	[8713,     1,    0],
#	[   0,     0,    0]
#]

var rooms = {} #U: Keep track of every room's info

var loading = false
var new_is_done = false
var peers_done_loading = []

func _ready():
	var _tmp = get_tree().connect('connected_to_server', self, 'enter_server')

#U: When I enter a room I send my map's info to the server
func enter_server():
	rpc_id(1, 'create_room', Data.my_room)

#U: Selects a new position for a room
func get_new_pos():
	#A: Starting position is the middle
	var x = 1
	var y = 1
	
	while map[x][y]:
		var move = randi() % 4
		if move == 0 and 0 < y: #A: Up
			y -= 1
		elif move == 1 and y < 2: #A: Down
			y += 1
		elif move == 2 and 0 < x: #A: Left
			x -= 1
		elif move == 3 and x < 2: #A Right
			x += 1
	
	return Vector2(x, y)

#U: [SERVER ONLY] Creates a new room when a player enters the server
remotesync func create_room(room):
	Global.rpc('toggle_pause') #A: Wait until everyone has loaded
	loading = true
	new_is_done = false
	peers_done_loading = []
	
	var pos = get_new_pos()
	room.pos = pos
	
	var id = get_tree().get_rpc_sender_id()
	
	Debug.logger(1, ['Created %s\'s room at %s %s' % [Data.get_id_name(id), pos.x, pos.y]])
	
	rpc_id(id, 'add_everyone', map, rooms)
	rpc('add_one', id, room)

#U: Adds everyone's rooms when I enter a server
remotesync func add_everyone(m, info):
	map = m
	for id in info:
		add_room(id, info[id])
	
	rpc_id(1, 'finished_loading_everyone')

#U: Adds only one room
remotesync func add_one(id, room):
	add_room(id, room)
	
	rpc_id(1, 'finished_loading')

#U: Adds a new room to the map
func add_room(id, room):
	var pos = room.pos
	map[pos.x][pos.y] = id
	rooms[id] = room
	
	load_room(id)
	
	Debug.logger(2, ['Added %s\'s room at %s %s' % [Data.get_id_name(id), pos.x, pos.y], map])

#U: Loads a room
func load_room(id):
	#TODO: Actually load the room
	load_player(id)
	
	Debug.logger(2, ['Finished loading %s' % Data.get_id_name(id)])

#U: Loads a player and places them in their room
func load_player(id):
	var player = preload('res://src/player/player.tscn').instance()
	player.set_name(str(id))
	player.set_network_master(id)
	var x = 1024*(rooms[id].pos.x - 0.5)
	var y = 600*(rooms[id].pos.y - 0.5)
	player.position = Vector2(x, y) #A: The middle of their room
	player.place_camera(Vector2(x, y))
	player.Map = self
	$players.add_child(player)

#U: Keeps track of when the new player finished loaded everyone else
remotesync func finished_loading_everyone():
	new_is_done = true
	
	var peers = get_tree().get_network_connected_peers()
	if len(peers_done_loading) == (len(peers)+1):
		post_load()

#U: Keeps track of who finished loading the new player
remotesync func finished_loading():
	var id = get_tree().get_rpc_sender_id()
	peers_done_loading.append(id)
	Debug.logger(3, ['%s finished loading' % Data.get_id_name(id)])
	
	var peers = get_tree().get_network_connected_peers()
	if len(peers_done_loading) == (len(peers)+1) and new_is_done:
		post_load()

#U: After everyone has loaded
func post_load():
	Global.rpc('toggle_pause')
	
	Debug.logger(1, ['Finished loading'])

#TODO: Handle players disconnecting
#TODO: Let players update their rooms while online
