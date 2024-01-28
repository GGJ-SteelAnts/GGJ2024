extends Control

@onready var label : Label = get_node("NinePatchRect/VBoxContainer/Label")
@onready var scoreLabel : Label = get_node("NinePatchRect/VBoxContainer/ScoreLabel")

@onready var winSong : AudioStreamWAV = preload("res://Scenes/Sounds/QuestCompleted.wav")
@onready var loseSong : AudioStreamWAV = preload("res://Scenes/Sounds/QuestFailed.wav")

func _ready():
	get_node("/root/Menu").hide()

func _on_texture_button_pressed():
	get_node("/root/Menu").show()
	get_node("/root/EndScreen").queue_free()
	queue_free()

func SongPlay(win):
	if win:
		$NinePatchRect/VBoxContainer/AnimatedSprite2D.play("Shit")
		$NinePatchRect/VBoxContainer/AnimatedSprite2D.scale = Vector2(8,8)
		$AudioStreamPlayer2D.stream = winSong
	else:
		$NinePatchRect/VBoxContainer/AnimatedSprite2D.play("default")
		$NinePatchRect/VBoxContainer/AnimatedSprite2D.scale = Vector2(2,2)
		$AudioStreamPlayer2D.stream = loseSong
	$AudioStreamPlayer2D.play()
