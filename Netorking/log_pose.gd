extends Node

const DEFAULT_PORT = 1072 #OP episode number reference
const DEFAULT_WS = "ws://localhost:1072" #default localhost websocket
#for connecting two instances separately... maybe...
const PEER_PORT = 1073 
const PEER_WS = "ws://localhost:1073"

#unsure if these are needed
signal peer_connected(peer_id: int)
signal peer_disconnected(peer_id: int)

#servers peers
#var server = WebSocketServer.new()
var server := TCPServer.new()
var socket := WebSocketPeer.new()


# Called when the node enters the scene tree for the first time.
#may not be needed idk
func _ready() -> void:
	#startServer(DEFAULT_PORT)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	server polling should happen here
	#socket.poll()
	pass

#will start a tcp server
#returns 0 on success, 1 on failure
#pass an int port number
func startServer(port:int) -> int:
	if server.listen(port) != OK:
		print("Unable to start server")
		set_process(false)
		return 1
	print("TCP server started on port "+ str(port))
	return 0
	
#will start a websocket client
#returns 0 on success, 1 on failure
#and connect it to specified websocket url
func startClient(ws_url:String) -> int:
	if socket.connect_to_url(ws_url) != OK:
		print("Unable to connect.")
		set_process(false)
		return 1
	print("Client connected to "+ ws_url)
	return 0
	
func closeServer():
	server.stop()
	
func closeClient():
	socket.close()

#pretty sure this closes everything when the game exits
func _exit_tree():
	closeServer()
	closeClient()
	
