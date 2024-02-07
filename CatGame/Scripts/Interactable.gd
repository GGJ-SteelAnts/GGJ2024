extends "res://Scripts/Item.gd"

var player : Player
var canInteract : bool			# whether is player close enough to interact with the item
var isInteracting : bool	# set to true when the Interact() is called. Must be reset to interact again

var anger : int

@export var itemTypeEnum : Enums.ItemTypeEnum = Enums.ItemTypeEnum.Empty

@onready var label = $Label
@onready var sprite = $Sprite2D

var gui = null

signal _onItemInteracted(anger)

func _ready():
	canInteract = false
	isInteracting = false
	player = null
	anger = 10
	
func _process(delta):
	if Input.is_action_just_released("Interact") && canInteract:
		isInteracting = true
		Interact()

func Interact():
	print("Interacting with " + itemName)
	#isInteracting = false
	_onItemInteracted.emit(anger)
	
	get_node("/root/Map/Dynamics/Enemy").makeHimAngry(anger) #když dropne item call


func _on_area_2d_body_entered(body):
	if body is Player && !isInteracting:
		canInteract = true
		player = body
		gui = body.get_node("Gui")
		label.visible = true

func _on_area_2d_body_exited(body):
	canInteract = false
	if body is Player:
		gui = null
		label.visible = false

func AddScorePoints():
	pass
