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

func _ready():
	var _tmp = get_tree().connect('connected_to_server', self, 'enter_server')

#U: When I enter a room I send my map's info to the server
func enter_server():
	get_tree().set_pause(true) #U: I'll wait until I've loaded everyone else, and everyone has loaded me
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

#U: Adds a new room to the map
remotesync func add_room(id, room):
	var pos = room.pos
	map[pos.x][pos.y] = id
	rooms[id] = room
	
	#TODO: Actually load the room
	
	Debug.logger(2, ['Added %s\'s room at %s %s' % [id, pos.x, pos.y], map])
	rpc_id(id, 'finished_loading') #A: Tells them I finished loading them

#U: [SERVER ONLY] Creates a new room
remotesync func create_room(room):
	var pos = get_new_pos()
	room.pos = pos
	
	var id = get_tree().get_rpc_sender_id()
	
	Debug.logger(1, ['Created %s\'s room at %s %s' % [id, pos.x, pos.y]])
	rset_id(id, 'map', map) #A: Updates their map
	rpc('add_room', id, room)

#U: Keeps track of who finished loading me
var peers_done_loading = []
remotesync func finished_loading():
	var id = get_tree().get_rpc_sender_id()
	peers_done_loading.append(id)
	Debug.logger(3, ['%s loaded me' % id])
	
	var peers = get_tree().get_network_connected_peers()
	
	if len(peers_done_loading) == (len(peers)+1):
		get_tree().set_pause(false)
		get_node('../lobby/chatroom').send_message('joined')
		
		Debug.logger(1, ['Finished loading'])
		#TODO: Position player in their room

#TODO: Handle players disconnecting
#TODO: Let players update their rooms while online
