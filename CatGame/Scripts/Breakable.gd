extends "res://Scripts/Interactable.gd"

# Graphics and animations
@export var breakAnimation : AnimatedSprite2D
@export var breakSound : AudioStreamWAV

@onready var guiUi = get_node("/root/Map/Dynamics/Player/Gui")


func _ready():
	super._ready()
	
	if has_node("Animation"):
		breakAnimation = $Animation

func Break():
	UpdateTasks()
	print("%s broke." % itemName)

func UpdateTasks():
	for Task in [guiUi.Task1, guiUi.Task2, guiUi.Task3]:
		if Task.TaskType == Enums.TaskTypeEnum.DontBreak:
			Task.resetResource()
		elif Task.TaskType == Enums.TaskTypeEnum.BreakItem:
			#print(Task.item)
			#print(itemTypeEnum)
			if Task.item == itemTypeEnum:
				Task.currentAmount += 1

func PlayAnimation():
	if breakAnimation == null:
		return
	if sprite:
		sprite.visible = false
	rotation_degrees = int(startRotation)
	breakAnimation.play("default")
