extends Node

func _ready():
	var args = OS.get_cmdline_args()
	if "server" in args:
		load_scene("res://server/server.tscn")
	elif "client" in args and "disabled" not in args:
		load_scene("res://client/client.tscn")

func load_scene(scene_path):
	var scene = load(scene_path).instantiate()
	get_tree().root.add_child.call_deferred(scene)
