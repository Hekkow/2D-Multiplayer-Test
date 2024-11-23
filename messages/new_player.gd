extends Message
class_name NewPlayerMessage
var type = Types.NewPlayer
var id: int
var position: Vector2
func _init(_id, _position):
	id = _id
	position = _position
func _to_string():
	return "ID: " + str(id) + ", position: " + str(position)
