extends Camera

export var distance = 4.0
export var height = 2.0

var held_mouse_pos = Vector2()
var cam_lock = false
var cam_rot_speed = .005


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process_input(true)
	set_physics_process(true)
	#set_as_toplevel(true)

func _physics_process(delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0, 1, 0)
	
	var offset = pos - target
	
	offset = offset.normalized() * distance
	offset.y = height
	
	pos = target + offset
	
	look_at_from_position(pos, target, up)
	if Input.is_action_pressed("mouse_look"):
		held_mouse_pos = get_viewport().get_mouse_position()
		cam_lock = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)		
	else:
		cam_lock = false
		Input.warp_mouse_position(held_mouse_pos)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	
func _input(event):
	if event is InputEventMouseMotion and cam_lock:
		var offset = held_mouse_pos - event.position
		#var rot = Vector3(offset.x, offset.y, 0)
		get_parent().get_parent().rotate(Vector3(0, 1, 0), offset.x * cam_rot_speed)
		print(get_parent().get_parent().name)