extends Control

const DEFAULT_PORT = 1072 #OP episode number reference
const DEFAULT_IP = "localhost" #default localhost websocket

@onready var address = $MarginContainer/VBoxContainer/ip
@onready var port = $MarginContainer/VBoxContainer/port
@onready var btn_host = $MarginContainer/VBoxContainer/HBoxContainer/btn_host
@onready var btn_join = $MarginContainer/VBoxContainer/HBoxContainer/btn_join

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

func _player_connected(_id):
	if multiplayer.is_server():
		print("Player 1 connected")
	else:
		print("Player 2 connected")
	get_tree().change_scene_to_file("res://Scenes/Game/World.tscn")
	#var sim = load("res://Scenes/Game/World.tscn").instantiate()
	# Connect deferred so we can safely erase it from the callback.
	#sim.game_finished.connect(_end_game, CONNECT_DEFERRED)

	#get_tree().get_root().add_child(sim)
	hide()
	
func _player_disconnected():
	if multiplayer.is_server():
		print("Client disconnected")
	else:
		print("Server disconnected")

func _connected_ok():
	print("it worked!!!")
	#get_tree().change_scene_to_file("res://Scenes/Game/World.tscn")
	#var sim = load("res://Scenes/Game/World.tscn").instantiate()
	
func _connected_fail():
	print("failed to connect...")
	
func _server_disconnected():
	print("server disconnected...")

#we need this apparently
func _end_game():
	if has_node("/root/Board"):
		# Erase immediately, otherwise network might show
		# errors (this is why we connected deferred above).
		get_node(^"/root/Board").free()
		show()

	multiplayer.set_multiplayer_peer(null) # Remove peer.
	btn_host.set_disabled(false)
	btn_join.set_disabled(false)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")

#create server on button press
func _on_btn_host_pressed() -> void:
	peer = WebSocketMultiplayerPeer.new()
	var err = peer.create_server(DEFAULT_PORT)
	if err != OK:
		# Is another server running?
		print("Can't host, address in use.")
		return
	multiplayer.set_multiplayer_peer(peer)
	btn_host.set_disabled(true)
	btn_host.set_pressed_no_signal(true)
	btn_join.set_disabled(true)
	btn_host.set_pressed_no_signal(true)
	print("Waiting for player on port "+str(DEFAULT_PORT))


func _on_btn_join_pressed() -> void:
	var ip = address.get_text()
	if not ip.is_valid_ip_address() and not ip == "localhost":
		print("IP address is invalid.")
		return
	peer = WebSocketMultiplayerPeer.new()
	peer.create_client("ws://"+ip+":"+str(DEFAULT_PORT))
	multiplayer.set_multiplayer_peer(peer)
	print("Connecting to "+"ws://"+ip+":"+str(DEFAULT_PORT))
