extends "res://Scripts/Fallable.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	itemName = "Glass"
	itemType = ItemType.GLASS
	canFall = true
