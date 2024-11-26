extends CharacterBody2D
class_name Player

const speed = 300.0
@onready var sprite = $Sprite2D
signal movement
var playing = false
var id = -1
var previous_input_dir = Vector2(0, 0)
var previous_rotation = 0
func _physics_process(delta):
	if not playing:
		move_and_slide()
		return
	var input_dir = Input.get_vector("left", "right", "up", "down")
	set_velo(input_dir)
	set_rotate()
	if input_dir != previous_input_dir or sprite.rotation != previous_rotation:
		movement.emit(id, input_dir, sprite.rotation)
	previous_input_dir = input_dir
	previous_rotation = sprite.rotation
	move_and_slide()
	
func set_pos(pos):
	position = pos
func get_pos():
	return position
func set_velo(direction):
	velocity = direction.normalized() * speed
func get_rotate():
	return sprite.rotation
	
func set_rotate(angle=null):
	if angle:
		sprite.rotation = angle
	else:
		sprite.look_at(get_global_mouse_position())
func _to_string():
	return "Player id: " + str(id)
