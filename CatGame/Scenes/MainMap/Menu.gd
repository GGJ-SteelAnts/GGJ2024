extends Control

var map = preload("res://Scenes/MainMap/map.tscn")

@onready var mainMenu = get_node("MainMenu")
@onready var credits = get_node("Credits")
@onready var controls = get_node("Controls")

func _on_start_game_pressed():
	var game = map.instantiate()
	game.menu = self
	game.name = "Map"
	get_tree().get_root().add_child(game, true)
	hide()


func _on_exit_game_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("Exit") && visible:
		get_tree().quit()


func _on_credits_pressed():
	mainMenu.hide()
	credits.show()


func _on_controls_pressed():
	controls.show()
	mainMenu.hide()


func _on_texture_button_pressed():
	mainMenu.show()
	controls.hide()
	credits.hide()
