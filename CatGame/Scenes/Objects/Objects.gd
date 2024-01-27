extends Node2D

enum ObjectsTypes {Eat, Drop, Nothing = -1}
@export var type = ObjectsTypes.Nothing
@export var interactable = false
@export var canInteract = true

@export var spriteNormal : Texture
@export var spriteAction : Texture

@export var particles : GPUParticles2D

@onready var label = get_node("Label")
@onready var sprite = get_node("Sprite2D")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var onGround = true
var num = 0

func _process(delta):
	if interactable && Input.is_action_pressed("Interact") && canInteract:
		Interaction()
		interactable = false
	if !onGround:
		position = position.move_toward(Vector2(position.x,602), delta * (100 + num))
		num += 10

func _on_area_2d_body_entered(body):
	if body.name == "Player" && canInteract:
		label.visible = true
		interactable = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		label.visible = false
		interactable = false

func Interaction():
	if type == ObjectsTypes.Eat:
		if spriteAction != null:
			sprite.texture = spriteAction
			canInteract = false
	if type == ObjectsTypes.Drop:
		onGround = false
		canInteract = false
		num = 0
