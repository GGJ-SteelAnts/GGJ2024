extends Node

class_name PlayerStats

var stats : Dictionary

# Called when the node enters the scene tree for the first time.
func _init():	
	#Stat.new(_name, _max, _updateAmount, _value = _max, _change = 0, _min = 0, _mods = [], _mults = [])
	stats = {
		"Stamina": Stat.new("Stamina", 10, -0.1),
		"Hunger": Stat.new("Hunger", 10, 0.5, 0),
		"Needs": Stat.new("Needs", 10, 0.2, 0)
		}
	#test()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func UpdateStats(delta):
	for stat in stats.values():
		stat.Update(delta)

func test():
	# tests
	print(stats["Stamina"].Value())		# <--- 50
	stats["Stamina"].AddModifier(20)
	stats["Stamina"].AddModifier(20)
	stats["Stamina"].AddModifier(20)
	print(stats["Stamina"].Value())		# <--- 110
	stats["Stamina"].RemoveModifier(20)
	print(stats["Stamina"].Value())		# <--- 90
	stats["Stamina"].AddMultiplier(2)
	print(stats["Stamina"].Value())		# <--- 180
	stats["Stamina"].RemoveModifier(1.5)
	print(stats["Stamina"].Value())		# <--- 180
	

func Feed(_amount):
	stats["Hunger"].Take(_amount)
	print("Cat ate food and has now " + str(stats["Hunger"].Value()))

func FeedFull():
	stats["Hunger"].Min()

func Relief():
	stats["Needs"].Min()
