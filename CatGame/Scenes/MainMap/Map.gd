extends Node2D

var menu : Control

func _input(event):
	if event.is_action_pressed("Exit"):
		menu.show()
		queue_free()
