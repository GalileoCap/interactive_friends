extends Node

var max_level = -1
var log_text = ''

func logger(level, args):
	print(level, ' ', args)
	if max_level == -1 or level <= max_level:
		for x in args:
			log_text += str(x) + ' '
