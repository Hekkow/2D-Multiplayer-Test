extends Message
class_name InputMovementMessage
var type = Types.InputMovement
var id
var movement_input: Vector2
var rotation: float
var input_request_id: int
func _init(_id, _movement_input, _rotation, _input_request_id):
	id = _id
	movement_input = _movement_input
	rotation = _rotation
	input_request_id = _input_request_id
