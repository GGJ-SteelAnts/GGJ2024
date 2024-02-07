extends Node2D

var bubbleGUI : Sprite2D
var bubbleItem : Sprite2D

var thinkInterval : Timer
var bubbleDuration : Timer

var player : Player
var stats : PlayerStats

var worstStat : Stat

# Called when the node enters the scene tree for the first time.
func _ready():
	bubbleGUI = $BubbleGUI
	bubbleItem = $BubbleGUI/BubbleItem
	thinkInterval = $ThinkInterval
	bubbleDuration = $BubbleDuration
	bubbleGUI.visible = false
	
	worstStat = null

# TO DO: implement critical treshold for  each stat
func EvaluateWorseStat() -> Variant:
	var _stat = null
	for s in stats.stats.values():
		if s.Critical():
			if _stat != null:
				if s.CriticalValue() > _stat.CriticalValue():
					_stat = s
			else:
				_stat = s
	if _stat != null:
		print("The worst stat is %s" % _stat.name)
	return _stat


func _on_think_interval_timeout():
	worstStat = EvaluateWorseStat()
	
	if worstStat != null:
		# For more info see PlayerStats.gd file.
		var _icon = load("res://Scenes/Objects/ThoughtIcons/" + worstStat.name + ".png")
		bubbleItem.texture = _icon
		bubbleGUI.visible = true
		bubbleDuration.start()
		worstStat.Print()
	else:
		thinkInterval.start()


func _on_bubble_duration_timeout():
	bubbleGUI.visible = false
	thinkInterval.start()


func _on_player_on_player_loaded():
	player = get_node("/root/Map/Dynamics/Player")
	stats = player.playerStats
	thinkInterval.start()
	print("Bubble initialized")
