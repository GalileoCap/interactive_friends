extends Node

puppet var players = {}
var me = {
	'name': 'PLAYER',
}

func update_me():
	rpc_id(1, 'update_player', me)

remotesync func update_player(info): 
	var id = get_tree().get_rpc_sender_id()
	players[id] = info
	
	rset('players', players)

func user_exited(id):
	players.erase(id)
	rset('players', players)
