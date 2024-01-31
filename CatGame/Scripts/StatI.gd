extends Stat
class_name StatI

func Value():
	var total_value = baseValue
	for mod in modifiers:
		total_value += mod
	for mod in multipliers:
		total_value *= mod
	return int(total_value)
