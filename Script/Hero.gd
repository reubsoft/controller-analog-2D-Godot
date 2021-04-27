extends KinematicBody2D


const GRAVITY = 600
const DEACCEL = 15
const ACCEL = 8
const JUMP_SPEED = -250
const MAX_SPEED = 120
var vel = Vector2()
var dir = Vector2()
var freeJump = true
var attacking = false
var control
var movimentTouch = false

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")


export(NodePath) var controller

# Called when the node enters the scene tree for the first time.
func _ready():
	control = get_node(controller)
	control.connect("touchStatus", self, "_touchStatus")
	
func _physics_process(delta):
	_input_moviment(delta)
	_physics_moviment(delta)
	
func _physics_moviment(delta):
	vel.y += GRAVITY * delta
	
	var hvel = vel
	hvel.y = 0
	
	var acceleration = DEACCEL
	if dir.dot(hvel) > 0:
		acceleration = ACCEL
		if !attacking:
			animation_mode.travel("Walk")
	else:
		if !attacking:
			animation_mode.travel("Idle")
		
	var target = dir * MAX_SPEED
	
	hvel = hvel.linear_interpolate(target, acceleration * delta)
	vel.x = hvel.x
	vel = move_and_slide(vel, Vector2.UP)
	
func _input_moviment(delta):
	dir = Vector2()
	
#	Parte do teclado
	var forward = Input.is_action_pressed("ui_right")
	var backward = Input.is_action_pressed("ui_left")
	var upward = Input.is_action_just_pressed("ui_accept")
	var attack = Input.is_action_pressed("attack")
	
#	Parte touch
	if movimentTouch:
		var mv = control.relativePosition()
		dir.x += mv.x
	
	dir.x += int(forward) - int(backward)
	if dir.x > -1:
		$root.scale.x = 1
	else:
		$root.scale.x = -1
	
	dir = dir.normalized()
	
	if upward and $RayCast2D.is_colliding():
		_jump()
		
	if attack:
		_attack()
		
func _jump():
	freeJump = false
	animation_mode.travel("Jump")
	vel.y = JUMP_SPEED
	
func _attack():
	attacking = true
	animation_mode.travel("Attack")
	attacking = false

func _touchStatus(value):
	movimentTouch = value
