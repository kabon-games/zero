extends Node

const PORT = 4533
const MAX_CONNEXIONS = 20

var me: int = -1

signal player_connected
signal player_joined(id: int)

func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connexion_fail)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_player_joined)
	
func join_game(address):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
func host_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNEXIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	me = 1
	
func quit_game():
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	
func _on_connexion_fail():
	quit_game()
	
func _on_connected_to_server():
	me = multiplayer.get_unique_id()
	player_connected.emit()

func _on_player_joined(id: int):
	player_joined.emit(id)
