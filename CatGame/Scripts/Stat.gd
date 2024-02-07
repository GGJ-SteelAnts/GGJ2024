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

var criticalTreshold : float	# <-1, 1>. See Critical() for more detail

func _init(_name, _max, _updateAmount, _value = _max, _min = 0, _criticalTreshold = 0, _mods = [], _mults = []):
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
	criticalTreshold = _criticalTreshold
	modifiers = _mods
	multipliers = _mults
	
	Print(true)


func Value():
	var total_value = baseValue
	for mod in modifiers:
		total_value += mod
	for mod in multipliers:
		total_value *= mod
	return total_value

# Returns whether the stat reached critical level
# The value criticalTreshold (CT) should be between -1 and 1,
# Where the sign represents if the critical range is below or above CT 
# And absolute value represents the value in %
# -0.25 means when the Stat's value goes below 25%, it will become critical.
# 0.75 means when Stat's value goes above 75% of maxValue, it will become critical.
func Critical() -> bool:
	var _val = abs(criticalTreshold)
	var _frac = Value() / maxValue
	if criticalTreshold < 0:
		return _frac < _val
	if criticalTreshold > 0:
		return _frac > _val
	return false

func CriticalValue() -> float:
	var _frac = Value() / maxValue
	if criticalTreshold < 0:
		return 1 - _frac
	if criticalTreshold > 0:
		return _frac
	return 0

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
	
func Print(full = false):
	if full:
		print("Stat %s. \nVal: %.2f (Min: %d | Max: %d | UpA: %.2f | CT: %.2f)" % [name, baseValue, minValue, maxValue, updateAmount, criticalTreshold])
	else:
		print("%s: %.2f (CV %.2f)" % [name, Value(), CriticalValue()])
