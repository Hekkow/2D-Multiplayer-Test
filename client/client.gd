extends Node2D
class_name Client

var udp := PacketPeerUDP.new()
var players = {}
var player
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
		if message.type == Message.Types.Connected:
			player = Factory.player(self, message.id, message.spawn_position, true)
			player.movement.connect(send_inputs)
			for id in message.positions:
				players[id] = Factory.player(self, id, message.positions[id])
		elif message.type == Message.Types.NewPlayer:
			players[message.id] = Factory.player(self, message.id, message.position)
		elif message.type == Message.Types.Movement:
			for id in players:
				
				players[id].set_pos(message.positions[id])
				players[id].set_rotate(message.rotations[id])
		
func send_inputs(id, input_dir, _rotation):
	#print(_rotation)
	udp.put_packet(var_to_bytes(InputMovementMessage.new(id, input_dir, _rotation).serialize()))
