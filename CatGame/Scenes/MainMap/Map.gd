extends Node2D

var menu : Control

func _input(event):
	if event.is_action_released("Exit"):
		menu.show()
		queue_free()
"res://Scenes/Sounds/Cat/Meow01.wav"
