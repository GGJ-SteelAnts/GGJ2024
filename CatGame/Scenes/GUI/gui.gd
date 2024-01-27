extends Node

@onready var Task1 = get_node("Task")
@onready var Task2 = get_node("Task2")
@onready var Task3 = get_node("Task3")
@onready var Clock = get_node("Clock")

@export var NewTaskTime = 20.0

var ActualTaskTime = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Task1.TaskType == Enums.TaskTypeEnum.Empty && Task2.TaskType != Enums.TaskTypeEnum.Empty:
		Task1.copyResource(Task2)
		Task2.resetResource()
		Task1.taskTimerBar.value = Task2.taskTimerBar.value
		Task2.taskTimerBar.value = 0
	if Task1.TaskType == Enums.TaskTypeEnum.Empty && Task3.TaskType != Enums.TaskTypeEnum.Empty:
		Task1.copyResource(Task3)
		Task3.resetResource()
		Task1.taskTimerBar.value = Task3.taskTimerBar.value
		Task3.taskTimerBar.value = 0
	if Task2.TaskType == Enums.TaskTypeEnum.Empty && Task3.TaskType != Enums.TaskTypeEnum.Empty:
		Task2.copyResource(Task3)
		Task3.resetResource()
		Task2.taskTimerBar.value = Task3.taskTimerBar.value
		Task3.taskTimerBar.value = 0

	if ActualTaskTime > NewTaskTime:
		if Task1.TaskType == Enums.TaskTypeEnum.Empty:
			Task1.TaskType = Task1.chooseTask()
			Task1.generateTaskStats(Task1.TaskType)
			Task1.taskTimerBar.max_value = Task1.time
			Task1.taskTimerBar.value = Task1.time
		elif Task2.TaskType == Enums.TaskTypeEnum.Empty:
			Task2.TaskType = Task2.chooseTask()
			Task2.generateTaskStats(Task2.TaskType)
			Task2.taskTimerBar.max_value = Task2.time
			Task2.taskTimerBar.value = Task2.time
		elif Task3.TaskType == Enums.TaskTypeEnum.Empty:
			Task3.TaskType = Task3.chooseTask()
			Task3.generateTaskStats(Task3.TaskType)
			Task3.taskTimerBar.max_value = Task3.time
			Task3.taskTimerBar.value = Task3.time
		ActualTaskTime = 0.0
	pass

func _on_timer_timeout():
	ActualTaskTime += 1
	
	Task1.taskTimerBar.value -= 1
	Task2.taskTimerBar.value -= 1
	Task3.taskTimerBar.value -= 1
	
	if Task1.taskTimerBar.value <= 0:
		Task1.resetResource()
	if Task2.taskTimerBar.value <= 0:
		Task2.resetResource()
	if Task3.taskTimerBar.value <= 0:
		Task3.resetResource()
	pass # Replace with function body.
