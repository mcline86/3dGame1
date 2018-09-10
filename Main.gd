extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var keyLock = false
var lockTime = 0
 

export(NodePath) var menu_popup


func _ready():
	set_process(true)
	set_process_input(true)	
	get_node(menu_popup).hide()
	var hPos = (self.get_viewport().size.x / 2) - (get_node(menu_popup).rect_size.x / 2)
	var vPos = (self.get_viewport().size.y / 2) - (get_node(menu_popup).rect_size.y / 2) 
	get_node(menu_popup).rect_position = Vector2(hPos, vPos)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	

func _process(delta):
	if Input.is_action_pressed("ui_cancel") and !keyLock:
		keyLock = true
		if get_node(menu_popup).visible:
			get_node(menu_popup).hide()
		else:
			get_node(menu_popup).show()
	
	if Input.is_action_just_released("ui_cancel"):
		lockTime = 0
		
	if keyLock:
		lockTime += delta
		if lockTime > .5:
			lockTime = 0
			keyLock = false


func _input(event):
	pass


func _on_resume_pressed():
	get_node(menu_popup).hide()


func _on_reset_pressed():
	get_tree().reload_current_scene()


func _on_exit_pressed():
	get_tree().quit()
