extends Node2D

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
