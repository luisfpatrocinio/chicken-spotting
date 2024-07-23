extends Node3D

@onready var switchSetupTimer: Timer = get_node("SwitchSetupTimer");
@onready var pressStartLabel = get_node("CanvasLayer/PressStartLabel");
@onready var displays = get_node("Monsters");
var flashValue: float = 1.0;
var currentDisplay: int = 0;

func _ready():
	Global.playBGM("title");

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

func _on_show_press_start_timer_timeout():
	pressStartLabel.visible = !pressStartLabel.visible;


func _on_switch_setup_timer_timeout():
	flashValue = 1.0;
	$Scenario/Wall.global_position.x -= randf_range(2.0, 4.0);
	$Scenario/Wall2.global_position.x -= randf_range(2.0, 4.0);
	currentDisplay += 1;
	currentDisplay = wrap(currentDisplay, 0, displays.get_child_count());
	switchSetupTimer.wait_time = randf_range(4.0, 6.0);
