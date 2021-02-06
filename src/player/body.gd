extends KinematicBody2D

const MOTION_SPEED = 200.0

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

func _ready():
	puppet_pos = position

func _physics_process(_delta):
	var motion = Vector2()

	if is_network_master():
		if Input.is_action_pressed('ui_left'):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed('ui_right'):
			motion += Vector2(1, 0)
		if Input.is_action_pressed('ui_up'):
			motion += Vector2(0, -1)
		if Input.is_action_pressed('ui_down'):
			motion += Vector2(0, 1)

		rset('puppet_motion', motion)
		rset('puppet_pos', position)
	else:
		position = puppet_pos
		motion = puppet_motion

	var _tmp = move_and_slide(motion * MOTION_SPEED)
	if not is_network_master():
		puppet_pos = position #To avoid jitter
