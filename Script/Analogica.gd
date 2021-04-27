extends Node2D


############    CONFIG    ############
export(int) var distanceStick = 20
export(bool) var drawNoTouch = false
export(Array, Rect2) var deadPixelRect

############    VAR    ############
var posAnalog = Vector2()
var touchNumber = [Vector2(), Vector2()]
var touch = false
var zoomCam
var weightCam
var angleStick
############    SIGNAL    ############
signal touchStatus

func _ready():
	posAnalog = get_viewport().canvas_transform.xform(global_position)  # Convert global position to viewport position
	zoomCam = Vector2(get_viewport_transform().x.x, get_viewport_transform().y.y)
	weightCam = get_viewport_transform().origin
	emit_signal("touchStatus", touch)
	
	
func _process(delta):
	if touch:
		updateJoystickView()
		
func relativePosition():
	return touchNumber[1]-touchNumber[0]
	
func relativeAngle():
	return angleStick


func _input(event):
	if event is InputEventScreenTouch:
		if deadPixel(event.position):
			touch = true
			originPosition(event.position)
			touchNumber[0] = event.position
			touchNumber[1] = event.position
			if !event.pressed:
				touch = false
				originPosition(posAnalog)
			emit_signal("touchStatus", touch)
	if event is InputEventScreenDrag:
			touchNumber[1] = event.position
		

func updateJoystickView():
	var dist = touchNumber[0].distance_to(touchNumber[1])
	angleStick = touchNumber[1].angle_to_point(touchNumber[0])
	if dist > distanceStick:
			dist = distanceStick
	$Stick.position = Vector2(dist,0).rotated(angleStick)
	
	
func originPosition(viewPos) -> void:
	global_position = get_viewport().canvas_transform.affine_inverse().xform(viewPos) #Convert position viewport to global position
	$Base.position = Vector2.ZERO
	$Stick.position = Vector2.ZERO

func deadPixel(viewPos):
	#positon size
	
	for i in range(deadPixelRect.size()):
		if(viewPos.x >= deadPixelRect[i].position.x and viewPos.x < deadPixelRect[i].size.x):
			if(viewPos.y >= deadPixelRect[i].position.y and viewPos.y < deadPixelRect[i].size.y):
				return false
	return true
