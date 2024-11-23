extends Node
var _player_scene = load("res://player.tscn")

func player(obj, _id, _position, _playing=false):
	var new_player = _player_scene.instantiate()
	obj.add_child(new_player)
	new_player.position = _position
	new_player.id = _id
	new_player.playing = _playing
	return new_player
