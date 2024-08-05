extends Node3D

@onready var switchSetupTimer: Timer = get_node("SwitchSetupTimer");
@onready var pressStartLabel = get_node("CanvasLayer/PressStartLabel");
@onready var displays = get_node("Monsters");
@onready var connectPlayersNode = get_node("CanvasLayer/ConnectPlayers");
var flashValue: float = 1.0;
var currentDisplay: int = 0;
var pressedStart = false;
var askingPlayers = false;
var gameStarted: bool = false;
#var connecting: bool = false;

func _ready():
	Global.playBGM("title");
	Global.players.clear();
	Interface.resetInterface();
	
	showAskingPlayer();
	
func _input(event):		
	if event.is_action_pressed("ui_accept"):
		if !askingPlayers and !pressedStart:
			pressedStart = true;
			$ShowPressStartTimer.wait_time = 0.10
			Global.playSFX("start");
			await get_tree().create_timer(1).timeout;
			showAskingPlayer();
		elif askingPlayers:
			Global.playSFX("start");			
			Global.transitionToScene("game");
	
	if askingPlayers:
		pass
		#Global.numberOfPlayers = max(1, len(Input.get_connected_joypads()));
		
		
func _process(delta):
	# Reduce flash effect
	var _sp = flashValue / 10.0;
	flashValue = move_toward(flashValue, 0.0, _sp)
	$CanvasLayer/Flash.modulate.a = flashValue;
	
	for i in range(displays.get_child_count()):
		var _display = displays.get_child(i);
		_display.visible = currentDisplay == i

	$CameraPivot.global_position.x = 0.0 + sin(Time.get_ticks_msec()/2000.0) * 0.10;
	$CameraPivot.look_at(Vector3.ZERO);
	%DancingChicken.look_at($CameraPivot.global_position * Vector3(0, 0, -1))
	
	manageAskingPlayers();

func showAskingPlayer():
	askingPlayers = true;
	pressStartLabel.visible = false;		
	$ShowPressStartTimer.stop();

func manageAskingPlayers():
	if !askingPlayers:
		return;
	
	connectPlayersNode.visible = true;
	
	var _label = connectPlayersNode.get_node("PlayersNumberLabel") as Label;	
	var _instructionLabel = connectPlayersNode.get_node("EnterToContinueLabel") as Label;
	var _joypadNumber = len(Input.get_connected_joypads())
	var _playerNumber = len(Global.players);
	if _playerNumber > 0:	
		_label.text = str(_playerNumber) + (" players" if _playerNumber > 1 else " player");
	else:
		_label.text = "";
	
	var _enterStr = "START" if _joypadNumber >= 1 else "ENTER";

	#_instructionLabel.text = "Press " + _enterStr + " to continue.";
	
	var _timer = get_node("StartGameTimer") as Timer;
	if _timer.is_stopped() and len(Global.players) >= 3:
		_timer.start();
	
	# Exibir tempo para iniciar partida.
	if !_timer.is_stopped():
		_instructionLabel.text = "Starting in %s seconds." % floor(_timer.time_left);
	else:
		var _questionLabel = get_node("CanvasLayer/ConnectPlayers/QuestionLabel") as Label;
		_questionLabel.visible = Connection.connected;
		$CanvasLayer/ConnectPlayers/QRCODE.visible = Connection.connected;
		if Connection.connected:
			_instructionLabel.size.x = 400;
			_instructionLabel.position = Vector2(500 - 150, 360);		
			_instructionLabel.text = "Waiting for players";
		else:
			# Centralizar texto.
			_instructionLabel.size.x = 800;
			_instructionLabel.position = Vector2(0, 280);
			_instructionLabel.text = "Connecting" + str(".").repeat(int(Time.get_ticks_msec()/500) % 4);
		
	if gameStarted:
		_instructionLabel.text = "";

func _on_show_press_start_timer_timeout():
	pressStartLabel.visible = !pressStartLabel.visible;
	
func _on_switch_setup_timer_timeout():
	flashValue = 1.0;
	$Scenario/Wall.global_position.x -= randf_range(2.0, 4.0);
	$Scenario/Wall2.global_position.x -= randf_range(2.0, 4.0);
	currentDisplay += 1;
	currentDisplay = wrap(currentDisplay, 0, displays.get_child_count());
	switchSetupTimer.wait_time = randf_range(4.0, 6.0);


func _on_start_game_timer_timeout():
	Global.transitionToScene("game");
	gameStarted = true;
