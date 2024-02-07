extends Node2D

class_name Item

enum ItemType {
	DEFAULT,
	PLANT, 
	GLASS,
	FISHTANK,
	MOUSE,
	BOWL,
	CAN,
	NOTEBOOK,
	DORITOS
}


@export var itemName : String
@export var itemType : ItemType

var startPosition : Vector2
var startRotation : float

func _ready():
	itemName = "Defualt item"
	itemType = ItemType.DEFAULT
	startPosition = global_position
	startRotation = global_rotation
