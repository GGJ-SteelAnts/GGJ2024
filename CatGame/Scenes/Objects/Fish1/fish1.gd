extends Node2D

enum ObjectsTypes {Fish,Nothing = -1}
@export var type = ObjectsTypes.Nothing
@onready var label = get_node("Label")

func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		label.visible = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		label.visible = false
