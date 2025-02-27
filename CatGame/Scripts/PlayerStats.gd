extends RefCounted

class_name PlayerStats

var stats : Dictionary

# Called when the node enters the scene tree for the first time.
func _init():
	#Stat.new(_name, _max, _updateAmount, _value = _max, _min = 0, criticalTreshold = 0, _mods = [], _mults = [])
	
	# Each stat can have its own icon for bubble. It must be saved in: 
	# "res://Scenes/Objects/ThoughtIcons/"
	# with the same name as the stat and of type PNG
	# Example: "res://Scenes/Objects/ThoughtIcons/Needs.png"
	stats = {
		"Hunger": Stat.new(
			"Hunger", 			# Name
			100, 				# Max value
			3,  				# Update amount
			0,  				# Value
			0,  				# Min value
			0.5 				# Critical value
			),
		"Needs": Stat.new(
			"Needs", 			# Name
			100, 				# Max value
			2,  				# Update amount
			0,  				# Value
			0,  				# Min value
			0.65 				# Critical value
			)
		}
	#test()
	print("Stats initialized")

func GetStats():
	return stats

# Called every frame. 'delta' is the elapsed time since the previous frame.
func UpdateStats(delta):
	for stat in stats.values():
		stat.Update(delta)

func test():
	# tests
	print(stats["Hunger"].Value())		# <--- 50
	stats["Hunger"].AddModifier(20)
	stats["Hunger"].AddModifier(20)
	stats["Hunger"].AddModifier(20)
	print(stats["Hunger"].Value())		# <--- 110
	stats["Hunger"].RemoveModifier(20)
	print(stats["Hunger"].Value())		# <--- 90
	stats["Hunger"].AddMultiplier(2)
	print(stats["Hunger"].Value())		# <--- 180
	stats["Hunger"].RemoveModifier(1.5)
	print(stats["Hunger"].Value())		# <--- 180
	

func Feed(_amount):
	stats["Hunger"].Take(_amount)
	print("Cat ate food and has now " + str(stats["Hunger"].Value()))

func FeedFull():
	stats["Hunger"].Min()

func Relieve():
	stats["Needs"].Min()
