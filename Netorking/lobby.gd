extends Control

const DEFAULT_PORT = 1072 #OP episode number reference
const DEFAULT_IP = "localhost" #default localhost websocket

@onready var address = $MarginContainer/VBoxContainer/ip
@onready var port = $MarginContainer/VBoxContainer/port

var peer = null

# Called when the node enters the scene tree for the first time.
#may not be needed idk
func _ready() -> void:
	# Connect all the callbacks related to networking.
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_ok)
	multiplayer.connection_failed.connect(_connected_fail)
	multiplayer.server_disconnected.connect(_server_disconnected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	server polling should happen here
	#socket.poll()
	pass

func _player_connected():
	pass
func _player_disconnected():
	pass
func _connected_ok():
	pass
func _connected_fail():
	pass
func _server_disconnected():
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options/options_menu.tscn")

#create server on button press
func _on_btn_host_pressed() -> void:
	peer = WebSocketMultiplayerPeer.new()
	var err = peer.create_server(DEFAULT_PORT)
	if err != OK:
		# Is another server running?
		print("Can't host, address in use.")
		return
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for player...", true)


func _on_btn_join_pressed() -> void:
	var ip = address.get_text()
	if not ip.is_valid_ip_address() and not ip == "localhost":
		print("IP address is invalid.")
		return
	peer = WebSocketMultiplayerPeer.new()
	peer.create_client(DEFAULT_IP)
	multiplayer.set_multiplayer_peer(peer)
	print("Connecting...")
