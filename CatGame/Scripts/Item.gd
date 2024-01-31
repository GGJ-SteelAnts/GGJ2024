extends Node2D

class_name Item

enum ItemType {
	DEFAULT,
	PLANT, 
	GLASS,
	TANK,
	MOUSE,
	BOWL
}


@export var itemName : String
@export var itemType : ItemType

var startPosition : Vector2
var startRotation : float
