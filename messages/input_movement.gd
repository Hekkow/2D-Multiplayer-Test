extends Message
class_name InputMovementMessage
var type = Types.InputMovement
var id
var movement_input: Vector2
var rotation: float
func _init(_id, _movement_input, _rotation):
	id = _id
	movement_input = _movement_input
	rotation = _rotation
