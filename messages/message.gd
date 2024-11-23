class_name Message
enum Types {
	Connected,
	NewPlayer,
	Movement,
	InputMovement
}
func serialize():
	var d = {}
	for property in get_property_list():
		var n = property.name
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			d[n] = get(n)
	return d
