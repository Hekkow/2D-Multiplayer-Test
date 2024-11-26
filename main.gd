extends Node

func _ready():
	var args = OS.get_cmdline_args()
	if "server" in args:
		load_scene("res://server/server.tscn")
	elif "client" in args and "disabled" not in args:
		var n = null
		for i in args:
			if i.count("name") > 0:
				n = i.split("=")[1]
		load_scene("res://client/client.tscn", n)
		
func load_scene(scene_path, n=null):
	var scene = load(scene_path).instantiate()
	if n:
		scene.name = n
	get_tree().root.add_child.call_deferred(scene)
