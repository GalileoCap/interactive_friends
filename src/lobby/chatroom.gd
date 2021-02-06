extends Control

onready var MAP = get_node('../../map')

func _ready():
	$name_input.text = Data.me.name

func send_message(msg):
	$chat_input.text = ''
	rpc('receive_message', msg)

remotesync func receive_message(msg):
	var id = get_tree().get_rpc_sender_id()
	var sender_name = (Data.get_id_name(id))
	$chat_display.text += sender_name + ': ' + msg + '\n'

func change_name(new_name):
	rpc('receive_message', 'changed their name to %s' % new_name)
	
	Data.me.name = new_name
	Data.update_me()
