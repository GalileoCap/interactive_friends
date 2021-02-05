extends Node

#var players_done = []
#func load_player(id):
#	var player = preload('res://src/player/player.tscn').instance()
#	player.set_name(str(id))
#	player.set_network_master(id, true)
#	player.position = Data.players[id].pos
#	$player.add_child(player)
#
#remote func load_game(): #U: Syncronizes loading between all players
#	get_tree().set_pause(true)
#
#	for id in Data.players:
#		load_player(id)
#
#	#TODO: Load rooms
#
#	rpc_id(1, 'done_loading')
#
#remote func done_loading(): #U: Keeps track of which players are done loaded
#	var id = get_tree().get_rpc_sender_id()
#
#	assert(not id in players_done) #A: No repeated players
#
#	players_done.append(id)
#	if players_done.size() == Data.players.size():
#		rpc('post_load')
#
#remotesync func post_load(): #U: Starts the game after all players are done loading
#	if get_tree().get_rpc_sender_id() == 1: #A: Only the server is allowed to unpause
#		get_tree().set_pause(false)
#		#TODO: Start game
