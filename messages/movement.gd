extends Message
class_name MovementMessage
var type = Types.Movement
var positions: Dictionary
var rotations: Dictionary
var latest_request_ids: Dictionary
func _init(_positions, _rotations, _latest_request_ids):
	positions = _positions
	rotations = _rotations
	latest_request_ids = _latest_request_ids
