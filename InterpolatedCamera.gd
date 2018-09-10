extends InterpolatedCamera

var dragStart
var drag = false
var direction = Vector3()
var cameraVel = 300

func _ready():
	set_process_input(true)
	set_process(true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func _input(event):
	if event.is_action_pressed("Camera Drag"):
		drag = true
		dragStart = get_viewport().get_mouse_position()
	if event is InputEventMouseMotion:
		var dragDiff = get_viewport().get_mouse_position()
		if  dragDiff.x < dragStart.x:
			direction.x = -1
		if  dragDiff.x > dragStart.x:
			direction.x = 1
		if  dragDiff.z < dragStart.z:
			direction.z = -1
		if  dragDiff.z > dragStart.z:
			direction.z = -1
			
func _process(delta):
	Cam1.set_pos(