extends Node

var socket: WebSocketPeer;

func _ready():
	socket = WebSocketPeer.new();
	
	#var _err = socket.connect_to_url("localhost:5569");
	var _err = socket.connect_to_url("ws://onebuttonserver.onrender.com:10000");
	if _err != OK:
		print("Falha ao conectar com o Servidor: ", _err);
	else:
		print("Conectando ao servidor websocket: ", _err);

func _process(delta):
	socket.poll()
		
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		#print("Conectado.");
		while socket.get_available_packet_count():
			print("Packet: ", socket.get_packet())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
	elif state == WebSocketPeer.STATE_CONNECTING:
		#print("Conectando... ")
		pass
