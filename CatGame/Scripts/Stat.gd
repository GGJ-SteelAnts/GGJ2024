class_name Stat

enum StatType {
	STATIC, 
	INCREMENT, 
	DEPRECATE
}

var name : String				# name of the stat
var maxValue : float			# maximum possible value
var minValue : float			# minimum possible value, default 0
var baseValue : float			# actual value

var type : StatType				# Type of stat
var updateAmount : float		# how fast stat changes in time, 0 for time resilience

var modifiers : Array			# modifiers are add to base value
var multipliers : Array			# multipliers multiply the base value after applying modifiers


func _init(_name, _max, _updateAmount, _value = _max, _min = 0, _mods = [], _mults = []):
	name = _name
	baseValue = _value
	if _updateAmount > 0:
		updateAmount = _updateAmount
		type = StatType.INCREMENT
	elif _updateAmount < 0:
		updateAmount = _updateAmount * -1
		type = StatType.DEPRECATE
	else:
		type = StatType.STATIC
		updateAmount = 0
	maxValue = _max
	minValue = _min
	modifiers = _mods
	multipliers = _mults
	
	print("Stat %s created with default value: %.2f min: %d max: %d (%.2f)" % [name, baseValue, minValue, maxValue, updateAmount])


func Value():
	var total_value = baseValue
	for mod in modifiers:
		total_value += mod
	for mod in multipliers:
		total_value *= mod
	return total_value

func Frac():
	return baseValue / maxValue


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
	maxValue += _amount

func AddMultiplier(_amount):
	multipliers.push_back(_amount)
	maxValue *= _amount

func RemoveModifier(_amount):
	for i in range(0, len(modifiers)-1):
		if modifiers[i] == _amount:
			modifiers.pop_at(i)
			maxValue -= _amount
			return

func RemoveMultiplier(_amount):
	for i in range(0, len(multipliers)-1):
		if multipliers[i] == _amount:
			multipliers.pop_at(i)
			maxValue /= _amount
			return

func Min():
	baseValue = minValue

func Max():
	baseValue = maxValue

func Update(delta):
	if type == StatType.INCREMENT:
		Add(updateAmount * delta)
	elif type == StatType.DEPRECATE:
		Take(updateAmount * delta)
	
