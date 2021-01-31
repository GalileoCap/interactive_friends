extends Node

var players = {}

func register_player(id): #U: Creates a player when they join
	players[id] = {
		turn = players.size(),
		pos = Vector2(1024/(pow(2, players.size())), 600/2) #A: Middle of the screen
	}
	
	var player = preload('res://src/player/player.tscn').instance()
	player.set_name(str(id))
	player.set_network_master(id, true)
	player.position = players[id].pos
	player.DEBUG = $debug
	$players.add_child(player)
	
	$debug.logger(3, ['Registered player', id])

func unregister_player(id): #U: Deletes a player when they leave
	players.erase(id)
	get_node('players/'+str(id)).queue_free()
	
	$debug.logger(3, ['Unregistered player', id])
