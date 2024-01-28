extends "res://Scripts/Interactable.gd"

@export var breakAnimation : AnimatedSprite2D
var itemSprite : Sprite2D


signal onInteraction


func Break():
	print("Item broke")


func PlayAnimation():
	if breakAnimation == null:
		return
	if itemSprite:
		itemSprite.visible = false
	rotation_degrees = 0
	breakAnimation.play("default")
