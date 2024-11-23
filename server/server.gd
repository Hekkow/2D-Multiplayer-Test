extends Control
class_name Server

var server := UDPServer.new()
var peers = []
var spawn_locations = [Vector2(-200, -200), Vector2(300, 100)]
var player_positions = {}
var player_rotations = {}
var latest_player_id: int = 0
var starting_time
var players = []
var peer_player = {}
var packets_sent = 0
func _ready():
	server.listen(Data.port)
	starting_time = Time.get_ticks_msec()
	
func _process(_delta):
	server.poll()
	if server.is_connection_available():
		var peer: PacketPeerUDP = server.take_connection()
		var _packet = peer.get_packet()
		var spawn_location = spawn_locations[peers.size()]
		var player = Factory.player(self, latest_player_id, spawn_location)
		players.append(player)
		peer_player[peer] = player
		peer.put_packet(var_to_bytes(ConnectedMessage.new(latest_player_id, spawn_location, player_positions).serialize()))
		var existing_users_packet = var_to_bytes(NewPlayerMessage.new(latest_player_id, spawn_location).serialize())
		for i in peers:
			i.put_packet(existing_users_packet)
		peers.append(peer)
		latest_player_id += 1
	for peer in peers:
		var packet = peer.get_packet()
		if packet:
			var message = bytes_to_var(packet)
			peer_player[peer].set_velo(message.movement_input, _delta)
			peer_player[peer].set_rotate(message.rotation)
	
	update_player_locations()
	for peer in peers:
		peer.put_packet(var_to_bytes(MovementMessage.new(player_positions, player_rotations).serialize()))
	if peers.size() > 0:
		packets_sent += 1
		prints("packets sent", packets_sent)
		
func update_player_locations():
	for player in players:
		player_positions[player.id] = player.get_pos()
		player_rotations[player.id] = player.get_rotate()
