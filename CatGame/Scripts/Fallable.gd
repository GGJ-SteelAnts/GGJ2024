extends "res://Scripts/Breakable.gd"

# I added the falling logic to the Breakable item
# as most of the Breakable items do fall although this logic can be turned off with canFool param
var isFalling : bool
var isGrounded : bool
var groundHeight : float		# Y-axis position at where the item stops falling

# Set for each item separately
@export var canFall : bool
@export var fallingRotation : bool
@export var fallingSpeed : float		# Falling speed
@export var fallingAccel : float		# Falling speed increment

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	isFalling = false
	isGrounded = false
	groundHeight = 580
	
	# Default when forgot to set
	canFall = true
	fallingSpeed = 20
	fallingAccel = 10

func _process(delta):
	super._process(delta)
	Fall(delta)

func Fall(delta):
	if !canFall:
		return
	if isFalling:
		position = position.move_toward(Vector2(position.x, groundHeight + 5), delta * (fallingSpeed))
		if fallingRotation:
			rotation_degrees += 2
		fallingSpeed += fallingAccel
		if position.y >= groundHeight:
			#print("Hit the ground")
			isFalling = false
			isGrounded = true
			Break()

func Break():
	super.Break()
	PlayAnimation()
	add_to_group("Issues")

func Interact():
	super.Interact()
	if not isGrounded:
		isFalling = true
		canInteract = false
