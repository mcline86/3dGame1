extends KinematicBody


var gravity = -9.8
var velocity = Vector3()
var camera

var cap_mouse = false

const SPEED = 10
const ACCELERATE = 3
const DECELERATE = 5



func _ready():
	set_process(true)
	set_process_input(true)
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _physics_process(delta):
	var dir = Vector3()
	camera = get_node("cam_rig/Camera").get_global_transform()
	
	if Input.is_action_pressed("move_FW"):
		dir += -camera.basis[2]
	if Input.is_action_pressed("move_BW"):
		dir += camera.basis[2]
	if Input.is_action_pressed("move_LT"):
		dir += -camera.basis[0]
	if Input.is_action_pressed("move_RT"):
		dir += camera.basis[0]
	
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * SPEED
	var accel = DECELERATE
	if dir.dot(hv) > 0:
		accel = ACCELERATE
	
	hv = hv.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
