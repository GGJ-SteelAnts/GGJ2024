extends Node

@onready var Task1 = get_node("Task")
@onready var Task2 = get_node("Task2")
@onready var Task3 = get_node("Task3")
@onready var Clock = get_node("Clock")

@export var NewTaskTime = 20.0

var ActualTaskTime = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Task1.TaskType = Task1.chooseTask()
	Task1.taskTimerBar.value = NewTaskTime*3
	Task2.TaskType = Task2.chooseTask()
	Task2.taskTimerBar.value = NewTaskTime*3
	
	Task1.taskTimerBar.max_value = NewTaskTime*3
	Task2.taskTimerBar.max_value = NewTaskTime*3
	Task3.taskTimerBar.max_value = NewTaskTime*3
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Task1.TaskType == TaskTypeEnum.TaskTypeEnum.Empty && Task2.TaskType != TaskTypeEnum.TaskTypeEnum.Empty:
		Task1.TaskType = Task2.TaskType
		Task2.TaskType = TaskTypeEnum.TaskTypeEnum.Empty
		Task1.taskTimerBar.value = Task2.taskTimerBar.value
		Task2.taskTimerBar.value = 0
	if Task1.TaskType == TaskTypeEnum.TaskTypeEnum.Empty && Task3.TaskType != TaskTypeEnum.TaskTypeEnum.Empty:
		Task1.TaskType = Task3.TaskType
		Task3.TaskType = TaskTypeEnum.TaskTypeEnum.Empty
		Task1.taskTimerBar.value = Task3.taskTimerBar.value
		Task3.taskTimerBar.value = 0
	if Task2.TaskType == TaskTypeEnum.TaskTypeEnum.Empty && Task3.TaskType != TaskTypeEnum.TaskTypeEnum.Empty:
		Task2.TaskType = Task3.TaskType
		Task3.TaskType = TaskTypeEnum.TaskTypeEnum.Empty
		Task2.taskTimerBar.value = Task3.taskTimerBar.value
		Task3.taskTimerBar.value = 0

	if ActualTaskTime > NewTaskTime:
		if Task1.TaskType == TaskTypeEnum.TaskTypeEnum.Empty:
			Task1.TaskType = Task1.chooseTask()
			Task1.taskTimerBar.value = NewTaskTime*3
		elif Task2.TaskType == TaskTypeEnum.TaskTypeEnum.Empty:
			Task2.TaskType = Task2.chooseTask()
			Task2.taskTimerBar.value = NewTaskTime*3
		elif Task3.TaskType == TaskTypeEnum.TaskTypeEnum.Empty:
			Task3.TaskType = Task3.chooseTask()
			Task3.taskTimerBar.value = NewTaskTime*3
		ActualTaskTime = 0.0
	pass

func _on_timer_timeout():
	ActualTaskTime += 1
	
	Task1.taskTimerBar.value -= 1
	Task2.taskTimerBar.value -= 1
	Task3.taskTimerBar.value -= 1
	
	if Task1.taskTimerBar.value <= 0:
		Task1.TaskType = TaskTypeEnum.TaskTypeEnum.Empty
	if Task2.taskTimerBar.value <= 0:
		Task2.TaskType = TaskTypeEnum.TaskTypeEnum.Empty
	if Task3.taskTimerBar.value <= 0:
		Task3.TaskType = TaskTypeEnum.TaskTypeEnum.Empty
	pass # Replace with function body.
