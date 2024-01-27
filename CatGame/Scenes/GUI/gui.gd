extends Node

@onready var Task1 = get_node("TextureRect/Tasks")
@onready var Task2 = get_node("TextureRect2/Tasks")
@onready var Task3 = get_node("TextureRect3/Tasks")

@export var NewTaskTime = 20.0
var ActualTaskTime = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Task1.TaskType = Task1.chooseTask()
	Task2.TaskType = Task2.chooseTask()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Task1.TaskType == Task1.TaskTypes.Empty && Task2.TaskType != Task2.TaskTypes.Empty:
		Task1.TaskType = Task2.TaskType
		Task2.TaskType = Task1.TaskTypes.Empty
	if Task1.TaskType == Task1.TaskTypes.Empty && Task3.TaskType != Task3.TaskTypes.Empty:
		Task1.TaskType = Task3.TaskType
		Task3.TaskType = Task1.TaskTypes.Empty
	if Task2.TaskType == Task1.TaskTypes.Empty && Task3.TaskType != Task3.TaskTypes.Empty:
		Task2.TaskType = Task3.TaskType
		Task3.TaskType = Task1.TaskTypes.Empty
	
	ActualTaskTime += delta
	if ActualTaskTime > NewTaskTime:
		if Task1.TaskType == Task1.TaskTypes.Empty:
			Task1.TaskType = Task1.chooseTask()
		elif Task2.TaskType == Task2.TaskTypes.Empty:
			Task2.TaskType = Task2.chooseTask()
		elif Task3.TaskType == Task3.TaskTypes.Empty:
			Task3.TaskType = Task3.chooseTask()
		ActualTaskTime = 0.0
	pass

