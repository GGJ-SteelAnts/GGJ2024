extends "res://Scripts/Interactable.gd"

@export var breakAnimation : AnimatedSprite2D
var itemSprite : Sprite2D

@onready var guiUi = get_node("/root/Map/Dynamics/Player/Gui")
signal onInteraction


func Break():
	for Task in [guiUi.Task1, guiUi.Task2, guiUi.Task3]:
		if Task.TaskType == Enums.TaskTypeEnum.DontBreak:
			Task.resetResource()
		elif Task.TaskType == Enums.TaskTypeEnum.BreakItem:
			if Task.Item == $itemTypeEnum:
				gui.Task.currentAmount += 1

	print("Item broke")

func PlayAnimation():
	if breakAnimation == null:
		return
	if itemSprite:
		itemSprite.visible = false
	rotation_degrees = 0
	breakAnimation.play("default")
