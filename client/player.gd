extends CharacterBody2D
class_name Player

const speed = 300.0
@onready var sprite = $Sprite2D
signal movement
var playing = false
var id = -1

func _physics_process(delta):
	if not playing:
		move_and_slide()
		return
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	set_velo(input_dir)
	set_rotate()
	movement.emit(id, input_dir, sprite.rotation)
	move_and_slide()
	
func set_pos(pos):
	position = pos
func get_pos():
	return position
var packets_received = 0
func set_velo(direction, server=false):
	velocity = direction.normalized() * speed
	#if server:
		#packets_received += 1
		#prints("server id", id, "dir", direction, "velocity", velocity, "packets received", packets_received)
	#else:
		#prints("client id", id, "dir", direction, "velocity", velocity)
		
	
	
	
func get_rotate():
	return sprite.rotation
	
func set_rotate(angle=null):
	if angle:
		sprite.rotation = angle
	else:
		sprite.look_at(get_global_mouse_position())
