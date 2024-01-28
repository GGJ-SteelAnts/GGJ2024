extends "res://Scripts/Breakable.gd"

var isFalling : bool
var isGrounded : bool
var fallingSpeed : int		# Falling speed
var fallingAccel : int		# Falling speed increment
var groundHeight : int		# Y-axis position at where the item stops falling
var fallingRotation : bool
var sprite2D : Sprite2D
var isUsed : bool


func _ready():
	super._ready()
	isUsed = false
	isFalling = false
	isGrounded = false
	fallingSpeed = randi() % 50
	fallingAccel = 10
	groundHeight = 580
	fallingRotation = false
	
	anger = 35
	angerDamage = 35
	
	print("FallingSpeed " + str(fallingSpeed))
	itemName = "Fish tank"
	itemType = ItemType.TANK
	if has_node("Sprite2D"):
		sprite2D = $Sprite2D
	if  has_node("Animation"):
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

func Use():
	sprite2D.hide()
	breakAnimation.show()
	isUsed = true

func Interact():
	super.Interact()
	if !isUsed:
		Use()
		isInteracting = false
		return
	if not isGrounded:
		isFalling = true
		canInteract = false
	print("Interacting with fish tank")


func Break():
	super.Break()
	PlayAnimation()
	add_to_group("Issues")
