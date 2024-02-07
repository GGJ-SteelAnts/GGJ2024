extends "res://Scripts/Fallable.gd"

@export var angerMultiplier : float = 2

var fishSprite : Sprite2D
var isUsed : bool

func _ready():
	super._ready()
	canFall = true
	isUsed = false
	fallingSpeed = randi() % 50
	fallingAccel = 10
	fallingRotation = false
	
	anger = 25
	
	#print("FallingSpeed " + str(fallingSpeed))
	itemName = "Fish tank"
	itemType = ItemType.FISHTANK
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
	get_node("/root/Map/Dynamics/Enemy").makeHimAngry(anger) #když dropne item call

func Interact():
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
	get_node("/root/Map/Dynamics/Enemy").makeHimAngry(anger * angerMultiplier) #když dropne item call
