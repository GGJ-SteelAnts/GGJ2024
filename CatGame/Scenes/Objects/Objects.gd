extends Node2D

enum ObjectsTypes {Eat, EatAndDrop, EatGood, Drop, HideAndJail, Nothing = -1}
@export var type = ObjectsTypes.Nothing
@export var itemTypeEnum : Enums.ItemTypeEnum = Enums.ItemTypeEnum.Empty
@export var interactable = false
@export var canInteract = true

@export var angerDamage = 15

@export var spriteNormal : Texture
@export var spriteAction : Texture
@export var spriteAction2 : Texture

@export var particles : GPUParticles2D
@export var respawner : float = 10.0
var actualRespawner : float = 0.0

@onready var label = get_node("Label")
@onready var sprite = get_node("Sprite2D")
@onready var area = get_node("Area2D")
@onready var enemy = get_tree().get_first_node_in_group("Enemy")
@onready var player : Node2D = null

var gui = null

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var onGround = true
var num = 0

func _process(delta):
	actualRespawner += delta
	if type == ObjectsTypes.EatGood:
		if spriteAction != null:
			if actualRespawner > respawner && !canInteract:
				canInteract = true
				sprite.texture = spriteNormal
				actualRespawner = 0
			elif actualRespawner > respawner && canInteract:
				canInteract = false
				sprite.texture = spriteAction
				actualRespawner = 0
		
	if interactable && Input.is_action_just_released("Interact") && canInteract:
		Interaction(delta)
		
	if !onGround:
		position = position.move_toward(Vector2(position.x,602), delta * (100 + num))
		num += 10
	
	if position == Vector2(position.x,602) && !canInteract:
		add_to_group("Issues")
		
	if type == ObjectsTypes.HideAndJail:
		if spriteAction != null && spriteAction2 != null && player != null && player.canMove == false:
			if !player.visible:
				if (Input.is_action_just_pressed("Right")):
					sprite.texture = spriteAction
				elif (Input.is_action_just_pressed("Left")):
					sprite.texture = spriteAction2

func _on_area_2d_body_entered(body):
	if body.name == "Player" && canInteract:
		player = body
		gui = body.get_node("Gui")
		label.visible = true
		interactable = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		gui = null
		label.visible = false
		interactable = false

func Interaction(delta):
	if type == ObjectsTypes.Eat:
		if spriteAction != null:
			sprite.texture = spriteAction
			canInteract = false
			add_to_group("Issues")
			enemy.makeHimAngry(angerDamage)
			interactable = false
			label.visible = false
	elif type == ObjectsTypes.EatAndDrop:
		if spriteAction != null:
			sprite.texture = spriteAction
			enemy.makeHimAngry(angerDamage)
			type = ObjectsTypes.Drop
	elif type == ObjectsTypes.EatGood:
		if spriteAction != null:
			sprite.texture = spriteAction
			canInteract = false
			enemy.makeHimAngry(angerDamage)
			actualRespawner = 0
			interactable = false
			label.visible = false
			if gui.Task1.TaskType == Enums.TaskTypeEnum.CatchMouse:
				gui.Task1.currentAmount += 1
			if gui.Task2.TaskType == Enums.TaskTypeEnum.CatchMouse:
				gui.Task2.currentAmount += 1
			if gui.Task3.TaskType == Enums.TaskTypeEnum.CatchMouse:
				gui.Task3.currentAmount += 1
	elif type == ObjectsTypes.HideAndJail:
		if spriteAction != null && spriteAction2 != null && player != null:
			if player.visible:
				if !player.get_node("AnimatedSprite2D").flip_h:
					sprite.texture = spriteAction
				else:
					sprite.texture = spriteAction2
				player.hide()
				player.canMove = false
				var timer = get_node("Timer")
				var progressBar = get_node("ProgressBar")
				progressBar.visible = true
				timer.start()
			else:
				sprite.texture = spriteNormal
				player.show()
				player.canMove = true
				
				
				for Task in [gui.Task1, gui.Task2, gui.Task3]:
					if Task.TaskType == Enums.TaskTypeEnum.Sleep:
						Task.currentAmount += 1
						
	elif type == ObjectsTypes.Drop:
		onGround = false
		canInteract = false
		num = 0
		interactable = false
		label.visible = false
		if gui.Task1.TaskType == Enums.TaskTypeEnum.BreakItem:
			if gui.Task1.item == Enums.ItemTypeEnum.Vase and itemTypeEnum == Enums.ItemTypeEnum.Vase:
				gui.Task1.currentAmount += 1
			if gui.Task1.item == Enums.ItemTypeEnum.Laptop and itemTypeEnum == Enums.ItemTypeEnum.Laptop:
				gui.Task1.currentAmount += 1
			if gui.Task1.item == Enums.ItemTypeEnum.FishTank and itemTypeEnum == Enums.ItemTypeEnum.FishTank:
				gui.Task1.currentAmount += 1
			if gui.Task1.item == Enums.ItemTypeEnum.Glass and itemTypeEnum == Enums.ItemTypeEnum.Glass:
				gui.Task1.currentAmount += 1
				
		if gui.Task2.TaskType == Enums.TaskTypeEnum.BreakItem:
			if gui.Task2.item == Enums.ItemTypeEnum.Vase and itemTypeEnum == Enums.ItemTypeEnum.Vase:
				gui.Task2.currentAmount += 1
			if gui.Task2.item == Enums.ItemTypeEnum.Laptop and itemTypeEnum == Enums.ItemTypeEnum.Laptop:
				gui.Task2.currentAmount += 1
			if gui.Task2.item == Enums.ItemTypeEnum.FishTank and itemTypeEnum == Enums.ItemTypeEnum.FishTank:
				gui.Task2.currentAmount += 1
			if gui.Task2.item == Enums.ItemTypeEnum.Glass and itemTypeEnum == Enums.ItemTypeEnum.Glass:
				gui.Task2.currentAmount += 1
				
		if gui.Task3.TaskType == Enums.TaskTypeEnum.BreakItem:
			if gui.Task3.item == Enums.ItemTypeEnum.Vase and itemTypeEnum == Enums.ItemTypeEnum.Vase:
				gui.Task3.currentAmount += 1
			if gui.Task3.item == Enums.ItemTypeEnum.Laptop and itemTypeEnum == Enums.ItemTypeEnum.Laptop:
				gui.Task3.currentAmount += 1
			if gui.Task3.item == Enums.ItemTypeEnum.FishTank and itemTypeEnum == Enums.ItemTypeEnum.FishTank:
				gui.Task3.currentAmount += 1
			if gui.Task3.item == Enums.ItemTypeEnum.Glass and itemTypeEnum == Enums.ItemTypeEnum.Glass:
				gui.Task3.currentAmount += 1
			
		if gui.Task1.TaskType == Enums.TaskTypeEnum.DontBreak:
			gui.Task1.currentAmount += 1
		if gui.Task2.TaskType == Enums.TaskTypeEnum.DontBreak:
			gui.Task2.currentAmount += 1
		if gui.Task3.TaskType == Enums.TaskTypeEnum.DontBreak:
			gui.Task3.currentAmount += 1
