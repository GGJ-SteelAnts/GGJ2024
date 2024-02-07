extends "res://Scripts/Fallable.gd"

@export var feedAmount : float = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	itemName = "Canned Food"
	itemType = ItemType.CAN

func Interact():
	super.Interact()
	player.playerStats.Feed(feedAmount)
