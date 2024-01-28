extends Node2D

var player : Node2D
var canInteract : bool

var angerDamage : int


@onready var label = get_node("Label")
@onready var sprite = get_node("Sprite2D")


var gui = null

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var onGround = true
var num = 0

func _ready():
	canInteract = true
	player = null
	print("Created new interactable object")

func _process(delta):
	if Input.is_action_just_released("Interact") && canInteract:
		Interact()

func Interact():
	print("Interacting with item...")


func _on_area_2d_body_entered(body):
	if body.name == "Player" && canInteract:
		print(body)
		player = body
		gui = body.get_node("Gui")
		label.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		gui = null
		label.visible = false
