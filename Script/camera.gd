extends Camera2D


export(NodePath) var player
var target
var distance = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(player)
	pass # Replace with function body.
	
func _process(delta):
	var target_position = target.global_position
	var offset = target_position - global_position
	offset = offset.normalized() 
	var distancePlayer = global_position.distance_to(target_position)
	
	if distancePlayer > distance:
		global_translate(offset * distancePlayer *delta)
	
	
