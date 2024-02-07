extends "res://Scripts/Fallable.gd"

func _ready():
	super._ready()
	itemName = "Flower pot"
	itemType = ItemType.PLANT
	canFall = true
