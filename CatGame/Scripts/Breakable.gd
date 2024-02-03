extends "res://Scripts/Interactable.gd"

# Graphics and animations
var itemSprite : Sprite2D
@export var breakAnimation : AnimatedSprite2D
@export var breakSound : AudioStreamWAV

@onready var guiUi = get_node("/root/Map/Dynamics/Player/Gui")

# I added the falling logic to the Breakable item
# as most of the Breakable items do fall although this logic can be turned off with canFool param
@export var canFall : bool
@export var fallingRotation : bool
var isFalling : bool
var isGrounded : bool
var fallingSpeed : int		# Falling speed
var fallingAccel : int		# Falling speed increment
var groundHeight : int		# Y-axis position at where the item stops falling



func Break():
	for Task in [guiUi.Task1, guiUi.Task2, guiUi.Task3]:
		if Task.TaskType == Enums.TaskTypeEnum.DontBreak:
			Task.resetResource()
		elif Task.TaskType == Enums.TaskTypeEnum.BreakItem:
			#print(Task.item)
			#print(itemTypeEnum)
			if Task.item == itemTypeEnum:
				Task.currentAmount += 1
	print("%s broke." % itemName)

func Fall(delta):
	if !canFall:
		return
	if isFalling:
		position = position.move_toward(Vector2(position.x, groundHeight + 5), delta * (fallingSpeed))
		if fallingRotation:
			rotation_degrees += 2
		fallingSpeed += fallingAccel
		if position.y >= groundHeight:
			#print("Hit the ground")
			isFalling = false
			isGrounded = true
			Break()



func PlayAnimation():
	if breakAnimation == null:
		return
	if itemSprite:
		itemSprite.visible = false
	rotation_degrees = int(startRotation)
	breakAnimation.play("default")
