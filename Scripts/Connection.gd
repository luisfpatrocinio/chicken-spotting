extends Node

var connected: bool = false;
var socket: WebSocketPeer;
var connectedPlayersNumber: int = 0;

func _ready():
	tryToConnect();

func tryToConnect():
	socket = WebSocketPeer.new();
	
	#var _err = socket.connect_to_url("localhost:10000");
	var _err = socket.connect_to_url("wss://onebuttonserver.onrender.com/:10000");
	if _err != OK:
		print("Falha ao conectar com o Servidor: ", _err);
	else:
		print("Conectando ao servidor websocket: ", _err);

func _process(delta):
	socket.poll()
	
	# Operar em cada estado
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if !connected:
			print("CONECTADO!");
			connected = true;
		while socket.get_available_packet_count():
			var _packet = socket.get_packet();
			manageReceivedPacket(_packet);
			
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
		
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.
		
	elif state == WebSocketPeer.STATE_CONNECTING:
		print("Conectando... ")
		pass
		

func manageReceivedPacket(packet):
	var _packetStr = packet.get_string_from_utf8();
	var _packedDict = JSON.parse_string(_packetStr);
	print(_packedDict)
	match _packedDict["type"]:
		"joined":
			var _playerName = _packedDict["playerName"]
			print("Jogador %s entrou." % _playerName)
			Global.players.append({
				"name": _playerName,
				"count": 0
			})
		"guess":
			var _playerName = _packedDict["playerName"];
			var _guess = int(_packedDict["guess"]);
			
			# Encontrar esse player no array de players:
			var _ind = getPlayerIndexByName(_playerName);
			Global.players[_ind]["count"] = _guess;
			
			Interface.pulsePlayer(_ind);

func getPlayerIndexByName(name):
	for i in range(Global.players.size()):
		if Global.players[i]["name"] == name:
			return i
	return -1  # Retorna -1 se o jogador não for encontrado

func startGame():
	var _packet = {
		"type": "startGuessing"
	}
	socket.send_text(JSON.stringify(_packet))

func enableGuessing():
	var _packet = {
		"type": "enableGuessing"
	}
	socket.send_text(JSON.stringify(_packet))

func endGame(result: String):
	var _packet = {
		"type": "gameResult",
		"result": result
	}
	socket.send_text(JSON.stringify(_packet))


func _on_timer_timeout():
	if !connected:
		tryToConnect();
