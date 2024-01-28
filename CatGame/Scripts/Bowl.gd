extends "res://Scripts/Interactable.gd"

var isFilled : bool
var refillTime : float
var timer : float

func _ready():
	super._ready()
	itemName = "Feeding bowl"
	itemType = ItemType.BOWL
	isFilled = true
	refillTime = 5
	timer = 0
	print("Bowl created")

func _process(delta):
	super._process(delta)
	if !isFilled:
		if timer >= refillTime:
			$Food.visible = true
			isFilled = true
			timer -= refillTime
		else:
			timer += delta


func Interact():
	print("Eating from bowl")
	$Food.visible = false
	isFilled = false
	isInteracting = false
	super.Interact()
	label.visible = false


func _on_area_2d_body_entered(body):
	if body.name == "Player" && !isInteracting:
		if !isFilled:
			return
		canInteract = true
		player = body
		gui = body.get_node("Gui")
		label.visible = true
