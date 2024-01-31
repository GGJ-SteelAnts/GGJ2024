extends "res://Scripts/Breakable.gd"

func _ready():
	super._ready()
	canFall = true
	isFalling = false
	isGrounded = false
	fallingSpeed = randi() % 50
	fallingAccel = 10
	groundHeight = 580
	startPosition = global_position
	startRotation = global_rotation
	itemName = "Flower pot"
	itemType = ItemType.PLANT
	if has_node("Animation"):
		breakAnimation = $Animation


func _process(delta):
	super._process(delta)
	Fall(delta)


func Interact():
	super.Interact()
	if not isGrounded:
		isFalling = true
		canInteract = false
	#print("Interacting with plant")


func Break():
	super.Break()
	PlayAnimation()
	add_to_group("Issues")
