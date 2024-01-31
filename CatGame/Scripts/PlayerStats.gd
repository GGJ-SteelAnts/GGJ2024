extends Node

class_name PlayerStats

var stats : Dictionary

# Called when the node enters the scene tree for the first time.
func _init():	
	stats = {
		"Stamina": Stat.new("Stamina", 50),
		"Hunger": Stat.new("Hunger", 100, 0.5),
		"Needs": Stat.new("Needs", 100, 0.2)
		}
	#test()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func DeprecateStats(delta):
	for stat in stats.values():
		stat.Deprecate(delta)
		#print(stat.name + ": " + str(stat.Value()))

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
	
