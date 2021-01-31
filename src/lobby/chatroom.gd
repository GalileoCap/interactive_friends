extends Control

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			send_message($chat_input.text)
			$chat_input.text = ''

func send_message(msg):
	var id = get_tree().get_network_unique_id()
	rpc('receive_message', id, msg)

remotesync func receive_message(id, msg):
	$chat_display.text += str(id) + ': ' + msg + '\n'
