extends "res://Scripts/Breakable.gd"

var isFalling : bool
var fallingSpeed : int		# Falling speed
var fallingAccel : int		# Falling speed increment
var groundHeight : int		# Y-axis position at where the item stops falling

func _ready():
	super._ready()
	isFalling = false
	fallingSpeed = 20
	fallingAccel = 10
	groundHeight = 580

func _process(delta):
	super._process(delta)
	if isFalling:
		position = position.move_toward(Vector2(position.x, 620), delta * (fallingSpeed))
		rotation_degrees += 2
		fallingSpeed += fallingAccel
		
		if position.y >= groundHeight:
			#print("Hit the ground")
			isFalling = false
			add_to_group("Issues")




func Interact():
	isFalling = true
	#print("Interacting with plant")
