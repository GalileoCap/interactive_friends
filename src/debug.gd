extends Node

var max_level = -1

remotesync func logger(level, args):
	var id = get_tree().get_rpc_sender_id()
	if level <= max_level || max_level == -1:
		print(str(id)+': ', args)
