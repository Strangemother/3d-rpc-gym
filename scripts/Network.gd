extends Node


# The URL we will connect to
export var websocket_url = "ws://127.0.0.1:8000"

# Our WebSocketClient instance
var _client = WebSocketClient.new()


func _ready():
	DevTools.out('Network', 'Ready')
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var extra:String = "/ws/1621748408258"
	var url:String = websocket_url + extra
	DevTools.out('Network', 'Connecting to: ' + url)
	var err = _client.connect_to_url(url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	
	print('Network _ready result: ', err)

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)


func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	DevTools.out("Network", "Connected")
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	_client.get_peer(1).put_packet("Test packet".to_utf8())


func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var text:String = _client.get_peer(1).get_packet().get_string_from_utf8()
	
	DevTools.println(text)
	var m0 = text.substr(0,2)
	var mt = active.get(m0, null)
	print("Got data from server as ", m0, ': ', mt)
	if mt:
		emit_signal(mt, text.right(2))
		return 
	emit_signal('other', text)

signal source_code
signal expression
signal other

export var active:Dictionary = {
	'00': 'source_code', 
	'01': 'expression', 
	'02': 'other'
}


func _process(_delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
