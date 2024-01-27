extends Node2D

enum ObjectsTypes {Fish,Nothing = -1}
@export var type = ObjectsTypes.Nothing
@export var interactable = false

@onready var label = get_node("Label")

func _process(_delta):
	if interactable && Input.is_action_pressed("Interact"):
		Interaction()
		interactable = false

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		label.visible = true
		interactable = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		label.visible = false
		interactable = false

func Interaction():
	if type == ObjectsTypes.Fish:
		print("action")
	else:
		pass
