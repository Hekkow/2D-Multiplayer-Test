extends Message
class_name ConnectedMessage
var type = Types.Connected
var id: int
var spawn_position: Vector2
var positions: Dictionary
func _init(_id, _spawn_position, _positions):
	id = _id
	spawn_position = _spawn_position
	positions = _positions
#func _to_string():
	#return "ID: " + str(id) + ", location: " + str(positions)
