extends Node2D

enum ObjectsTypes {Eat,Nothing = -1}
@export var type = ObjectsTypes.Nothing
@export var interactable = false
@export var canInteract = true

@export var spriteNormal : Texture
@export var spriteAction : Texture

@export var particles : GPUParticles2D

@onready var label = get_node("Label")
@onready var sprite = get_node("Sprite2D")

func _process(_delta):
	if interactable && Input.is_action_pressed("Interact") && canInteract:
		Interaction()
		interactable = false

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
