extends "res://Scripts/Breakable.gd"

@export var angerMultiplier : float

var fishSprite : Sprite2D
var isUsed : bool

func _ready():
	super._ready()
	canFall = true
	isUsed = false
	isFalling = false
	isGrounded = false
	fallingSpeed = randi() % 50
	fallingAccel = 10
	groundHeight = 580
	fallingRotation = false
	
	anger = 15
	angerMultiplier = 2
	angerDamage = 35
	
	#print("FallingSpeed " + str(fallingSpeed))
	itemName = "Fish tank"
	itemType = ItemType.TANK
	if has_node("Sprite2D"):
		fishSprite = $Sprite2D
	if  has_node("Animation"):
		breakAnimation = $Animation

func _process(delta):
	super._process(delta)
	Fall(delta)


# Triggers eating fish
func Use():
	fishSprite.hide()
	breakAnimation.show()
	isUsed = true

func Interact():
	super.Interact()
	# Cat eats fish for first time
	if !isUsed:
		Use()
		isInteracting = false
		return
	# Cat breaks the tank when fish has been eaten before
	if not isGrounded:
		isFalling = true
		canInteract = false


func Break():
	super.Break()
	PlayAnimation()
	add_to_group("Issues")
