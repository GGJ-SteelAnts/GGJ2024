extends Control

enum TaskTypes {Empty, Hungry , Sleepy, Catnipy, Shitty}
var TaskType : TaskTypes
@onready var icon = get_node("Icon")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chooseArt(TaskType)
	pass

func chooseArt(task):
	match task:
		TaskTypes.Hungry:
			icon.texture = load("res://Scenes/Assets/Tasks/Hungry.png")
		TaskTypes.Sleepy:
			icon.texture = load("res://Scenes/Assets/Tasks/Sleepy.png")
		TaskTypes.Catnipy:
			icon.texture = load("res://Scenes/Assets/Tasks/Catnipy.png")
		TaskTypes.Shitty:
			icon.texture = load("res://Scenes/Assets/Tasks/Shitty.png")

func chooseTask():
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(1, TaskTypes.size() - 1)
	var taskString = TaskTypes.keys()[random_number]
	var task : TaskTypes
	match taskString:
		"Hungry":
			task = TaskTypes.Hungry
		"Sleepy":
			task = TaskTypes.Sleepy
		"Catnipy":
			task = TaskTypes.Catnipy
		"Shitty":
			task = TaskTypes.Shitty
	return task
