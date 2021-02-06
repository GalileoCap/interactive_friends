extends Node

puppet var players = {}
var me = {
	'name': 'PLAYER',
}
var my_room = {
	'data':[]
	} #TODO: How to send rooms, maybe send a matrix of the tiles?

func _ready():
	var _tmp = get_tree().connect('connected_to_server', self, 'enter_server')

func enter_server():
	rpc_id(1, 'get_players')
	update_me()

#U: Sends everyone my info
func update_me():
	rpc('update_player', me)

#U: Updates a player's info
remotesync func update_player(info):
	var id = get_tree().get_rpc_sender_id()
	players[id] = info
	
	Debug.logger(3, ['Updated %s\'s info' % Data.get_id_name(id)])

#U: [SERVER ONLY] Sends them everyone else's info
remote func get_players():
	var id = get_tree().get_rpc_sender_id()
	rset_id(id, 'players', players)

#U: Returns any id's name or the id itself
func get_id_name(id):
	return (players[id].name if id in players else str(id))

#*******************************************************************************

#TODO: Handle players disconnecting
