extends Node2D

var Map = null

func _ready():
	#U: Chooses which camera to use
	if self.get_name() == str(get_tree().get_network_unique_id()): #A: This is my node
		$camera.make_current()

#U: Places the camera in a given position
func place_camera(pos):
	$camera.position = pos

#U: Follows the body through the rooms with the camera
func follow_body():
	var pos = $body.global_position
	var map_pos = Vector2(floor(pos.x / 1024)+1, floor(pos.y / 600)+1) #TODO: Change with screen size
	var new_pos = Vector2(1024*(map_pos.x - 0.5), 600*(map_pos.y - 0.5))
	$camera.global_position = new_pos

func _process(_delta):
	follow_body()

#TODO: Get player position
