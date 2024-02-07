extends "res://Scenes/Objects/Objects.gd"

var time = 0.0
@onready var timer = get_node("Timer")
@onready var progressBar = get_node("ProgressBar")

func Interaction(delta):
	if type == ObjectsTypes.Eat:
		if spriteAction != null:
			sprite.texture = spriteAction
			canInteract = false
			add_to_group("Issues")
			enemy.makeHimAngry(angerDamage)
			interactable = false
			label.visible = false
	elif type == ObjectsTypes.EatAndDrop:
		if spriteAction != null:
			sprite.texture = spriteAction
			enemy.makeHimAngry(angerDamage)
			type = ObjectsTypes.Drop
	elif type == ObjectsTypes.EatGood:
		if spriteAction != null:
			sprite.texture = spriteAction
			canInteract = false
			enemy.makeHimAngry(angerDamage)
			actualRespawner = 0
			interactable = false
			label.visible = false
			if gui.Task1.TaskType == Enums.TaskTypeEnum.CatchMouse:
				gui.Task1.currentAmount += 1
			if gui.Task2.TaskType == Enums.TaskTypeEnum.CatchMouse:
				gui.Task2.currentAmount += 1
			if gui.Task3.TaskType == Enums.TaskTypeEnum.CatchMouse:
				gui.Task3.currentAmount += 1
	elif type == ObjectsTypes.HideAndJail:
		if spriteAction != null && spriteAction2 != null && player != null:
			if player.visible:
				if !player.get_node("CatAnimator").flip_h:
					sprite.texture = spriteAction
				else:
					sprite.texture = spriteAction2
				player.hide()
				player.canMove = false
				
				progressBar.visible = true
				timer.start()
			else:
				if progressBar.value == progressBar.max_value:
					if gui.Task1.TaskType == Enums.TaskTypeEnum.Sleep:
						gui.Task1.currentAmount += 1
					if gui.Task2.TaskType == Enums.TaskTypeEnum.Sleep:
						gui.Task2.currentAmount += 1
					if gui.Task3.TaskType == Enums.TaskTypeEnum.Sleep:
						gui.Task3.currentAmount += 1
				timer.stop()
				progressBar.value = 0
				progressBar.visible = false
				sprite.texture = spriteNormal
				player.show()
				player.canMove = true
					
	elif type == ObjectsTypes.Drop:
		onGround = false
		canInteract = false
		num = 0
		interactable = false
		label.visible = false
		if gui.Task1.TaskType == Enums.TaskTypeEnum.BreakItem:
			gui.Task1.currentAmount += 1
		if gui.Task2.TaskType == Enums.TaskTypeEnum.BreakItem:
			gui.Task2.currentAmount += 1
		if gui.Task3.TaskType == Enums.TaskTypeEnum.BreakItem:
			gui.Task3.currentAmount += 1
			
		if gui.Task1.TaskType == Enums.TaskTypeEnum.DontBreak:
			gui.Task1.currentAmount += 1
		if gui.Task2.TaskType == Enums.TaskTypeEnum.DontBreak:
			gui.Task2.currentAmount += 1
		if gui.Task3.TaskType == Enums.TaskTypeEnum.DontBreak:
			gui.Task3.currentAmount += 1


func _on_timer_timeout():
	progressBar.value += 1
	pass # Replace with function body.
