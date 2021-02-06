extends Node

#U: Pauses and unpauses the game
remotesync func toggle_pause():
	get_tree().set_pause(not get_tree().is_paused())
