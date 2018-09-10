extends Spatial


export(NodePath) var cam_control
export(NodePath) var cam_arm

var screenWidth 
var screenHeight

var cam_translate = Vector3(0, 0, 0)

var zoom = Vector3(0, 0, 0)

var edgeZone = 30
var scrollSpeed = 15

func _ready():
	# Called when the node is added to the scene for the first time.
	screenWidth = get_node(cam_control).get_viewport().get_size().x
	screenHeight = get_node(cam_control).get_viewport().get_size().y
	set_process_input(true)
	set_process(true)

func _process(delta):
	self.translate(cam_translate * delta)
	if zoom.y != 0:
		get_node(cam_arm).translate(zoom * delta)
		zoom.y = 0;
	

func _input(ev):
	
	if ev is InputEventMouseMotion:
		var mPos = get_viewport().get_mouse_position()
		
		if mPos.x < edgeZone:
			cam_translate.x = -scrollSpeed
		
		if mPos.x > screenWidth - edgeZone:
			cam_translate.x = scrollSpeed
		
		if mPos.y < edgeZone:
			cam_translate.z = -scrollSpeed
		
		if mPos.y > screenHeight - edgeZone:
			cam_translate.z = scrollSpeed
		
		if mPos.x > edgeZone and mPos.x < screenWidth - edgeZone:
			cam_translate.x = 0
		
		if mPos.y > edgeZone and mPos.y < screenHeight - edgeZone:
			cam_translate.z = 0
	
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_WHEEL_DOWN:
			zoom = Vector3(0, 5, 0)
		if ev.button_index == BUTTON_WHEEL_UP:
			zoom = Vector3(0, -5, 0)