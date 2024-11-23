extends Message
class_name MovementMessage
var type = Types.Movement
var positions: Dictionary
var rotations: Dictionary
func _init(_positions, _rotations):
	positions = _positions
	rotations = _rotations
