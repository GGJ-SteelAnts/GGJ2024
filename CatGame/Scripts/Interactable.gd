extends "res://Scripts/Item.gd"

var player : Node2D
var canInteract : bool
var isInteracting : bool

var anger : int = 10

@export var angerDamage = 15

@export var itemTypeEnum : Enums.ItemTypeEnum = Enums.ItemTypeEnum.Empty


@onready var gui = null
@onready var label = $Label
@onready var sprite = $Sprite2D

signal _onItemInteracted(anger)


func _ready():
	canInteract = false
	isInteracting = false
	player = null
	print("Created new interactable object")
	#var area = get_node("Area2D")
	#area.connect("body_entered", _on_area_2d_body_entered.bind(area))
	#area.connect("body_exited", _on_area_2d_body_exited.bind(area))
	

func _process(delta):
	if Input.is_action_just_released("Interact") && canInteract:
		isInteracting = true
		Interact()

func Interact():
	print("Interacting with item...")
	#isInteracting = false
	_onItemInteracted.emit(anger)
	
	get_node("/root/Map/Dynamics/Enemy").makeHimAngry(anger) #když dropne item call

	if gui.Task1.TaskType == itemTypeEnum:
		gui.Task1.currentAmount += 1
	if gui.Task2.TaskType == itemTypeEnum:
		gui.Task2.currentAmount += 1
	if gui.Task3.TaskType == itemTypeEnum:
		gui.Task3.currentAmount += 1


func _on_area_2d_body_entered(body):
	if body.name == "Player" && !isInteracting:
		canInteract = true
		player = body
		gui = body.get_node("Gui")
		label.visible = true

func _on_area_2d_body_exited(body):
	canInteract = false
	if body.name == "Player":
		gui = null
		label.visible = false
