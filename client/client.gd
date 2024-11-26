extends Node2D
class_name Client

var udp := PacketPeerUDP.new()
var players = {}
var player
var movements = []
var verified_position
func _ready():
	attempt_connect()
	
func attempt_connect():
	var connection_result = udp.connect_to_host("127.0.0.1", Data.port)
	if connection_result == OK:
		udp.put_packet("Attempting connect".to_utf8_buffer())
	else:
		print("OH NO")
		attempt_connect()

func _process(_delta):
	while udp.get_available_packet_count() > 0:
		var message = bytes_to_var(udp.get_packet())
		#if message.type != Message.Types.Movement: prints(name, player, message)
		if message.type == Message.Types.Connected:
			player = Factory.player(self, message.id, message.spawn_position, true)
			verified_position = message.spawn_position
			player.movement.connect(send_inputs)
			for id in message.positions:
				players[id] = Factory.player(self, id, message.positions[id])
			players[message.id] = player
		elif message.type == Message.Types.NewPlayer:
			players[message.id] = Factory.player(self, message.id, message.position)
		elif message.type == Message.Types.Movement:
			for id in players:
				if id == player.id:
					for i in range(len(movements)-1, -1, -1):
						if movements[i].input_request_id <= message.latest_request_ids[id]:
							movements.remove_at(i)
					verified_position = message.positions[id]
					var extrapolated_position = verified_position
					for movement in movements:
						extrapolated_position += movement.movement_input * 300.0/60.0
					#if extrapolated_position.distance_to(player.position) > 20:
					player.set_pos(extrapolated_position)
				else:
					players[id].set_pos(message.positions[id])
					players[id].set_rotate(message.rotations[id])

var input_request_id = 0

func send_inputs(id, input_dir, _rotation):
	#print(_rotation)
	var movement = InputMovementMessage.new(id, input_dir, _rotation, input_request_id)
	movements.append(movement)
	Packets.send(udp, movement, 0.2)
	input_request_id += 1
