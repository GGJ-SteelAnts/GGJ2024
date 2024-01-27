extends Control

var TaskType : Enums.TaskTypeEnum = Enums.TaskTypeEnum.Empty
var time : float = 0.0
var amount : int = 0
var item : Enums.ItemTypeEnum = Enums.ItemTypeEnum.Empty

@onready var icon = get_node("TaskFrame/Icon")
@onready var taskTimerBar = get_node("TaskTimerBar")
@onready var label = get_node("Label")

var BreakItemTexture = preload("res://Scenes/Assets/Tasks/Hungry.png")
var DontBreakTexture = preload("res://Scenes/Assets/Tasks/Sleepy.png")
var CatchMouseTexture = preload("res://Scenes/Assets/Tasks/Catnipy.png")
var PottyPottyTexture = preload("res://Scenes/Assets/Tasks/Shitty.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chooseArt(TaskType)
	pass

func copyResource(task):
	TaskType = task.TaskType
	time = task.time
	amount = task.amount
	item = task.item

func resetResource():
	TaskType = Enums.TaskTypeEnum.Empty
	time = 0.0
	amount = 0
	item = Enums.ItemTypeEnum.Empty

func chooseArt(task):
	match task:
		Enums.TaskTypeEnum.BreakItem:
			icon.texture = BreakItemTexture
		Enums.TaskTypeEnum.DontBreak:
			icon.texture = DontBreakTexture
		Enums.TaskTypeEnum.CatchMouse:
			icon.texture = CatchMouseTexture
		Enums.TaskTypeEnum.PottyPotty:
			icon.texture = PottyPottyTexture
		Enums.TaskTypeEnum.Empty:
			icon.texture = null
			
func chooseTask():
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(1, Enums.TaskTypeEnum.size() - 1)
	var taskString = Enums.TaskTypeEnum.keys()[random_number]
	var task : Enums.TaskTypeEnum
	match taskString:
		"BreakItem":
			task = Enums.TaskTypeEnum.BreakItem
		"DontBreak":
			task = Enums.TaskTypeEnum.DontBreak
		"CatchMouse":
			task = Enums.TaskTypeEnum.CatchMouse
		"PottyPotty":
			task = Enums.TaskTypeEnum.PottyPotty
	return task

func generateTaskStats(taskType):
	var rng = RandomNumberGenerator.new()
	match taskType:
		Enums.TaskTypeEnum.BreakItem:
			time = rng.randf_range(20, 30)
			var random_number = rng.randi_range(1, Enums.ItemTypeEnum.size() - 1)
			var itemString = Enums.TaskTypeEnum.keys()[random_number]
			match itemString:
				"Vase":
					item = Enums.ItemTypeEnum.Vase
					amount = rng.randi_range(1, 3)
				"Laptop":
					item = Enums.ItemTypeEnum.Laptop
					amount = rng.randi_range(1, 1)
				"FishTank":
					item = Enums.ItemTypeEnum.FishTank
					amount = rng.randi_range(1, 1)
				"Glass":
					item = Enums.ItemTypeEnum.Glass
					amount = rng.randi_range(1, 3)
			label.text = str(amount) + "/" + str(amount)
			
		Enums.TaskTypeEnum.DontBreak:
			time = rng.randf_range(20, 30)
			item = Enums.ItemTypeEnum.Empty
			amount = 0
			label.text = str(amount) + "/" + str(amount)
			
		Enums.TaskTypeEnum.CatchMouse:
			time = rng.randf_range(20, 30)
			item = Enums.ItemTypeEnum.Empty
			amount = 1
			label.text = str(amount) + "/" + str(amount)
			
		Enums.TaskTypeEnum.PottyPotty:
			icon.texture = PottyPottyTexture
			time = rng.randf_range(20, 30)
			item = Enums.ItemTypeEnum.Empty
			amount = 1
			label.text = str(amount) + "/" + str(amount)
			
		Enums.TaskTypeEnum.Empty:
			icon.texture = null
			time = 0
			item = Enums.ItemTypeEnum.Empty
			amount = 0
			label.text = ""
	pass
