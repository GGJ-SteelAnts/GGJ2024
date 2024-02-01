extends Node2D

@export var thoughtGUI : Sprite2D



var player : Player
var stats : PlayerStats

var worstStat : Stat

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Map/Dynamics/Player")
	stats = player.playerStats
	thoughtGUI.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TO DO: implement critical treshold for  each stat
func EvaluateWorseStat():
	worstStat = stats["Needs"]
	for s in stats.values():
		if s == worstStat:
			continue
		if s.Frac() < worstStat.Frac():
			worstStat = s
	return
