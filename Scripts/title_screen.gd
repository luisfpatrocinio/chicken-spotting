extends Node3D

@onready var switchSetupTimer: Timer = get_node("SwitchSetupTimer");
@onready var pressStartLabel = get_node("CanvasLayer/PressStartLabel");
@onready var displays = get_node("Monsters");
@onready var connectPlayersNode = get_node("CanvasLayer/ConnectPlayers");
var flashValue: float = 1.0;
var currentDisplay: int = 0;
var pressedStart = false;
var askingPlayers = false;

func _ready():
	Global.playBGM("title");
	Interface.resetInterface();
	
func _input(event):		
	if event.is_action_pressed("ui_accept"):
		if !askingPlayers and !pressedStart:
			pressedStart = true;
			$ShowPressStartTimer.wait_time = 0.10
			Global.playSFX("start");
			await get_tree().create_timer(1).timeout;
			askingPlayers = true;
			pressStartLabel.visible = false;		
			$ShowPressStartTimer.stop();
		elif askingPlayers:
			Global.playSFX("start");			
			Global.transitionToScene("game");
	
	if askingPlayers:
		Global.numberOfPlayers = max(1, len(Input.get_connected_joypads()));
		
func _process(delta):
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

func manageAskingPlayers():
	if !askingPlayers:
		return;
	
	connectPlayersNode.visible = true;
	
	var _label = connectPlayersNode.get_node("PlayersNumberLabel") as Label;	
	var _instructionLabel = connectPlayersNode.get_node("EnterToContinueLabel") as Label;
	var _joypadNumber = len(Input.get_connected_joypads())
	if _joypadNumber > 0:	
		_label.text = str(Global.numberOfPlayers) + (" players" if Global.numberOfPlayers > 1 else " player");
	else:
		_label.text = "Single Player Mode";
	
	var _enterStr = "START" if _joypadNumber >= 1 else "ENTER";
	_instructionLabel.text = "Press " + _enterStr + " to continue.";
	

func _on_show_press_start_timer_timeout():
	pressStartLabel.visible = !pressStartLabel.visible;
	
func _on_switch_setup_timer_timeout():
	flashValue = 1.0;
	$Scenario/Wall.global_position.x -= randf_range(2.0, 4.0);
	$Scenario/Wall2.global_position.x -= randf_range(2.0, 4.0);
	currentDisplay += 1;
	currentDisplay = wrap(currentDisplay, 0, displays.get_child_count());
	switchSetupTimer.wait_time = randf_range(4.0, 6.0);
