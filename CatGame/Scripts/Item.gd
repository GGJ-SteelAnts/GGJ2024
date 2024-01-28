extends Node2D

enum ItemType {
	DEFAULT,
	PLANT, 
	GLASS,
	TANK,
	MOUSE
}


@export var itemName : String
@export var itemType : ItemType
