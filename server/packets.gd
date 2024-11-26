extends Node

func send(peers, message, delay=0.001):
	var new_peers
	if peers is not Array:
		new_peers = [peers]
	else:
		new_peers = peers.duplicate()
	var packet = to_packet(message)
	await get_tree().create_timer(delay).timeout 
	for peer in new_peers:
		send_packet(peer, packet)
	
	
func send_packet(peer, packet):
	peer.put_packet(packet)
func to_packet(message):
	return var_to_bytes(message.serialize())
