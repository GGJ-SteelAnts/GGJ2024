extends Control

@onready var label : Label = get_node("NinePatchRect/VBoxContainer/Label")


func _on_texture_button_pressed():
	get_node("/root/Menu").show()
	get_node("/root/EndScreen").queue_free()
	queue_free()
