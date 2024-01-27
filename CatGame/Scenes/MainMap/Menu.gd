extends Control

var map = preload("res://Scenes/MainMap/map.tscn")

func _on_start_game_pressed():
	var game = map.instantiate()
	game.menu = self
	get_tree().get_root().add_child(game)
	hide()


func _on_exit_game_pressed():
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("Exit") && visible:
		get_tree().quit()
