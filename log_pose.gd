extends Node

const DEFAULT_PORT = 1072 #OP episode number reference


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startServer():
	var server = WebSocketServer.new()
	

func startClient():
	var client = WebSocketPeer.new()
