extends Control
class_name Server

var server := UDPServer.new()
var peers = []
var spawn_locations = [Vector2(-200, -200), Vector2(300, 100)]
var player_positions = {}
var player_rotations = {}
var player_latest_request_ids = {}
var latest_player_id: int = 0
var starting_time
var players = []
var peer_player = {}
func _ready():
	server.listen(Data.port)
	starting_time = Time.get_ticks_msec()
	
func _physics_process(_delta):
	server.poll()
	if server.is_connection_available():
		var peer: PacketPeerUDP = server.take_connection()
		peer.get_packet()
		var spawn_location = spawn_locations[peers.size()]
		var player = Factory.player(self, latest_player_id, spawn_location)
		players.append(player)
		peer_player[peer] = player
		Packets.send(peer, ConnectedMessage.new(latest_player_id, spawn_location, player_positions))
		Packets.send(peers, NewPlayerMessage.new(latest_player_id, spawn_location))
		peers.append(peer)
		player_latest_request_ids[latest_player_id] = -1
		latest_player_id += 1
		
	for peer in peers:
		var packet = peer.get_packet()
		if packet:
			var message = bytes_to_var(packet)
			#print(message)
			peer_player[peer].set_velo(message.movement_input)
			peer_player[peer].set_rotate(message.rotation)
			if message.input_request_id > player_latest_request_ids[message.id]:
				player_latest_request_ids[message.id] = message.input_request_id
	
	update_player_locations()
	var _packet = Packets.to_packet(MovementMessage.new(player_positions, player_rotations, player_latest_request_ids))
	for peer in peers:
		Packets.send_packet(peer, _packet)
		
func update_player_locations():
	for player in players:
		player_positions[player.id] = player.get_pos()
		player_rotations[player.id] = player.get_rotate()
