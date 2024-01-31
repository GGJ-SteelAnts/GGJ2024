class_name Stat

var name : String			# name of the stat
var maxValue : float		# maximum possible value
var minValue : float		# minimum possible value, default 0
var baseValue : float	# actual value

var deprecationRate : float	# how fast the current value will lower, default 0

var modifiers : Array		# modifiers are add to base value
var multipliers : Array		# multipliers multiply the base value after applying modifiers

func _init(_name, _value, _dep = 0, _max = _value, _min = 0, _mods = [], _mults = []):
	name = _name
	baseValue = _value
	deprecationRate = _dep
	maxValue = _max
	minValue = _min
	modifiers = _mods
	multipliers = _mults
	
	print("Stat " + name + " created with default value: " + str(baseValue) + "/" + str(maxValue))


func Value():
	var total_value = baseValue
	for mod in modifiers:
		total_value += mod
	for mod in multipliers:
		total_value *= mod
	return total_value

func Add(_amount):
	baseValue += _amount
	if baseValue > maxValue:
		baseValue = maxValue
	#print(name + ": " + str(Value()) + "(+" + str(_amount) + ")")

func Take(_amount):
	baseValue -= _amount
	if baseValue < minValue:
		baseValue = minValue
	#print(name + ": " + str(Value()) + "(-" + str(_amount) + ")")

func AddModifier(_amount):
	modifiers.push_back(_amount)

func AddMultiplier(_amount):
	multipliers.push_back(_amount)

func RemoveModifier(_amount):
	for i in range(0, len(modifiers)-1):
		if modifiers[i] == _amount:
			modifiers.pop_at(i)
			return

func RemoveMultiplier(_amount):
	for i in range(0, len(multipliers)-1):
		if multipliers[i] == _amount:
			multipliers.pop_at(i)
			return

func Deprecate(delta):
	Take(deprecationRate * delta)
