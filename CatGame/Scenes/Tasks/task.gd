extends Control

var TaskType : TaskTypeEnum.TaskTypeEnum
@onready var icon = get_node("TaskFrame/Icon")
@onready var taskTimerBar = get_node("TaskTimerBar")
@onready var label = get_node("Label")

var HungryTexture = preload("res://Scenes/Assets/Tasks/Hungry.png")
var SleepyTexture = preload("res://Scenes/Assets/Tasks/Sleepy.png")
var CatnipyTexture = preload("res://Scenes/Assets/Tasks/Catnipy.png")
var ShittyTexture = preload("res://Scenes/Assets/Tasks/Shitty.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chooseArt(TaskType)
	pass

func chooseArt(task):
	match task:
		TaskTypeEnum.TaskTypeEnum.Hungry:
			icon.texture = HungryTexture
		TaskTypeEnum.TaskTypeEnum.Sleepy:
			icon.texture = SleepyTexture
		TaskTypeEnum.TaskTypeEnum.Catnipy:
			icon.texture = CatnipyTexture
		TaskTypeEnum.TaskTypeEnum.Shitty:
			icon.texture = ShittyTexture
		TaskTypeEnum.TaskTypeEnum.Empty:
			icon.texture = null
			
func chooseTask():
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(1, TaskTypeEnum.TaskTypeEnum.size() - 1)
	var taskString = TaskTypeEnum.TaskTypeEnum.keys()[random_number]
	var task : TaskTypeEnum.TaskTypeEnum
	match taskString:
		"Hungry":
			task = TaskTypeEnum.TaskTypeEnum.Hungry
		"Sleepy":
			task = TaskTypeEnum.TaskTypeEnum.Sleepy
		"Catnipy":
			task = TaskTypeEnum.TaskTypeEnum.Catnipy
		"Shitty":
			task = TaskTypeEnum.TaskTypeEnum.Shitty
	return task
