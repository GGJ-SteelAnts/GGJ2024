extends Node2D

var player : Player
var stats : PlayerStats

var worstStat : Stat

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Map/Dynamics/Player")
	stats = player.playerStats


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func EvaluateWorseStat():
	
	return
