extends "res://Scripts/Interactable.gd"

var isFilled : bool
var refillTime : float
var timer : float

var feedAmount : int

func _ready():
	super._ready()
	itemName = "Feeding bowl"
	itemType = ItemType.BOWL
	isFilled = true
	refillTime = 5
	feedAmount = 2
	timer = 0
	#print("Bowl created")

func _process(delta):
	super._process(delta)
	if !isFilled:
		if timer >= refillTime:
			Refill()
		else:
			timer += delta


func Interact():
	#print("Eating from bowl")
	$Food.visible = false
	isFilled = false
	isInteracting = false
	player.playerStats.Feed(feedAmount)
	super.Interact()
	label.visible = false

func Refill():
	$Food.visible = true
	isFilled = true
	timer -= refillTime



func _on_area_2d_body_entered(body):
	if body.name == "Player" && !isInteracting:
		if !isFilled:
			return
		canInteract = true
		player = body
		gui = body.get_node("Gui")
		label.visible = true
