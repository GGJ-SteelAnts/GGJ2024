extends Control

var TaskType : Enums.TaskTypeEnum = Enums.TaskTypeEnum.Empty
var time : float = 0.0
var maxAmount : int = 0
var currentAmount : int = 0
@export var item : Enums.ItemTypeEnum = Enums.ItemTypeEnum.Empty

@onready var icon = get_node("Icon")
@onready var taskTimerBar = get_node("TaskTimerBar")
@onready var label = get_node("Label")

var BreakVaseTexture = preload("res://Scenes/Assets/Tasks/BreakVase1.png")
var BreakLaptopTexture = preload("res://Scenes/Assets/Tasks/BreakLaptop1.png")
var BreakFishTankTexture = preload("res://Scenes/Assets/Tasks/BreakFishTank1.png")
var BreakGlassTexture = preload("res://Scenes/Assets/Tasks/BreakGlass1.png")
var DontBreakTexture = preload("res://Scenes/Assets/Tasks/DontBreak1.png")
var CatchMouseTexture = preload("res://Scenes/Assets/Tasks/CatchMouse1.png")
var SleepTexture = preload("res://Scenes/Assets/Tasks/Sleep.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	chooseArt(TaskType)
	updateTaskLabel(TaskType)
	pass

func copyResource(task):
	TaskType = task.TaskType
	time = task.time
	maxAmount = task.maxAmount
	currentAmount = task.currentAmount
	item = task.item
	taskTimerBar.value = task.taskTimerBar.value
	icon.texture = task.icon.texture
	label.text = task.label.text

func resetResource():
	TaskType = Enums.TaskTypeEnum.Empty
	time = 0.0
	maxAmount = 0
	currentAmount = 0
	item = Enums.ItemTypeEnum.Empty
	taskTimerBar.value = 0
	icon.texture = null
	label.text = ""

func chooseArt(taskType):
	match taskType:
		Enums.TaskTypeEnum.BreakItem:
			match item:
				Enums.ItemTypeEnum.Vase:
					icon.texture = BreakVaseTexture
				Enums.ItemTypeEnum.Laptop:
					icon.texture = BreakLaptopTexture
				Enums.ItemTypeEnum.FishTank:
					icon.texture = BreakFishTankTexture
				Enums.ItemTypeEnum.Glass:
					icon.texture = BreakGlassTexture
		Enums.TaskTypeEnum.DontBreak:
			icon.texture = DontBreakTexture
		Enums.TaskTypeEnum.CatchMouse:
			icon.texture = CatchMouseTexture
		Enums.TaskTypeEnum.Sleep:
			icon.texture = SleepTexture
		Enums.TaskTypeEnum.Empty:
			icon.texture = null
			
func progressTask(taskType):
	if taskType == Enums.TaskTypeEnum.Empty:
		pass
	else:
		currentAmount += 1
			
func updateTaskLabel(taskType):
	if taskType == Enums.TaskTypeEnum.Empty:
		pass
	else:
		label.text = str(currentAmount) + " / " + str(maxAmount)
		
func isTaskFinished():
	if (TaskType == Enums.TaskTypeEnum.DontBreak):
		if (currentAmount != maxAmount) or time <= 0:
			return true
		else:
			return false
	else:
		if (currentAmount >= maxAmount) or time <= 0:
			return true
		else:
			return false

func wasTaskSuccessful():
	match TaskType:
		Enums.TaskTypeEnum.BreakItem:
			if currentAmount >= maxAmount:
				return true
			else :
				return false
		Enums.TaskTypeEnum.DontBreak:
			if currentAmount == maxAmount:
				#return true Adding points elsewhere
				return false
			else :
				return false
		Enums.TaskTypeEnum.CatchMouse:
			if currentAmount >= maxAmount:
				return true
			else :
				return false
		Enums.TaskTypeEnum.Sleep:
			if currentAmount >= maxAmount:
				return true
			else :
				return false
		Enums.TaskTypeEnum.Empty:
			return false

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
		"Sleep":
			task = Enums.TaskTypeEnum.Sleep
	return task

func generateTaskStats(taskType):
	var rng = RandomNumberGenerator.new()
	match taskType:
		Enums.TaskTypeEnum.BreakItem:
			time = rng.randf_range(20, 30)
			var random_number = rng.randi_range(1, Enums.ItemTypeEnum.size() - 1)
			var itemString = Enums.ItemTypeEnum.keys()[random_number]
			match itemString:
				"Vase":
					item = Enums.ItemTypeEnum.Vase
					maxAmount = rng.randi_range(1, 3)
				"Laptop":
					item = Enums.ItemTypeEnum.Laptop
					maxAmount = rng.randi_range(1, 1)
				"FishTank":
					item = Enums.ItemTypeEnum.FishTank
					maxAmount = rng.randi_range(1, 1)
				"Glass":
					item = Enums.ItemTypeEnum.Glass
					maxAmount = rng.randi_range(1, 3)
			
		Enums.TaskTypeEnum.DontBreak:
			time = rng.randf_range(20, 30)
			item = Enums.ItemTypeEnum.Empty
			maxAmount = 0
			
		Enums.TaskTypeEnum.CatchMouse:
			time = rng.randf_range(20, 30)
			item = Enums.ItemTypeEnum.Empty
			maxAmount = 1
			
		Enums.TaskTypeEnum.Sleep:
			icon.texture = SleepTexture
			time = rng.randf_range(20, 30)
			item = Enums.ItemTypeEnum.Empty
			maxAmount = 1
			
		Enums.TaskTypeEnum.Empty:
			icon.texture = null
			time = 0
			item = Enums.ItemTypeEnum.Empty
			maxAmount = 0
			label.text = ""
	pass
