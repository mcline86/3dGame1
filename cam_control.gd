extends Spatial


export(NodePath) var cam_control
export(NodePath) var cam_arm
export(NodePath) var cam
export(NodePath) var cam_eye

var screenWidth 
var screenHeight

var end = Vector3()
var begin = Vector3()
var path = []
const SPEED = 4.0

var target
var locked = false

var cam_translate = Vector3(0, 0, 0)

var zoom = Vector3(0, 0, 0)
var zoom_speed = 10


var edgeZone = 30
var scrollSpeed = 15

const ray_length = 1000

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
	
	if(path.size() > 1):
		var to_walk = delta * SPEED
		var to_watch = Vector3(0, 1, 0)
		while(to_walk > 0 and path.size >= 2):
			var pFrom = path[path.size() - 1]
			var pTo = path[path.size() - 2]
			to_watch = (pTo - pFrom).normalized()
			var d = pFrom.distance_to(pTo)
			if(d <= to_walk):
				path.remove(path.size() -1)
				to_walk -= d
			else:
				path[path.size() - 1] = pFrom.linear_interpolate(pTo, to_walk/d)
				to_walk = 0
		
		var atpos = path[path.size() - 1]
		var atdir = to_watch
		
		var t = Transform()
		t.origin = atpos
		t=t.looking_at(atpos + atdir, Vector3(0, 1, 0))
		get_node("Builder").set_transform(t)
				
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
			
	var camera = get_node(cam)
	var from = camera.project_ray_origin(ev.position)
	var to = from + camera.project_ray_normal(ev.position) * ray_length
	var space_state = get_world().get_direct_space_state()
	var hit = space_state.intersect_ray(from, to)
		
	if ev is InputEventMouseMotion:
		if hit.size() != 0:
			var global = get_node(cam_eye).get_global_transform()
			get_node(cam_eye).set_global_transform(Transform(get_node(cam_eye).get_global_transform().basis, hit.position))
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed:
		if hit.size() != 0:
			end = get_parent().get_node("Nav").get_closest_point_to_segment(from, to)
			begin = get_parent().get_node("Nav").get_closest_point(get_node("Builder").get_translation())
			_update_path()
			
func _update_path():
	var p = get_node("Nav").get_simple_path(begin, end, true)
	path = Array(p)
	path.invert()
	