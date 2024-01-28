extends "res://Scripts/Breakable.gd"

var isFalling : bool
var isGrounded : bool
var fallingSpeed : int		# Falling speed
var fallingAccel : int		# Falling speed increment
var groundHeight : int		# Y-axis position at where the item stops falling
var fallingRotation : bool


func _ready():
	super._ready()
	isFalling = false
	isGrounded = false
	fallingSpeed = randi() % 50
	fallingAccel = 10
	groundHeight = 580
	fallingRotation = true
	print("FallingSpeed " + str(fallingSpeed))
	itemName = "Flower pot"
	itemType = ItemType.PLANT
	if $Animation:
		breakAnimation = $Animation


func _process(delta):
	super._process(delta)
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
			
		


func Interact():
	super.Interact()
	if not isGrounded:
		isFalling = true
		canInteract = false
	print("Interacting with plant")


func Break():
	super.Break()
	PlayAnimation()
	add_to_group("Issues")
