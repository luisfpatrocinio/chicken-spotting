extends CanvasLayer

@onready var playerIconScene: PackedScene = preload("res://Scenes/interfacePlayerIcon.tscn")
@onready var playersNode: HBoxContainer = get_node("Players/HBoxContainer");
@onready var messagesSpace: Control = get_node("MessageSpace");
@onready var messageScene: PackedScene = preload("res://Scenes/gameMessage.tscn");

func _ready() -> void:
	pass
	
func _process(delta) -> void:
	for icon: TextureRect in playersNode.get_children():
		var _sp = 0.005;
		icon.scale = icon.scale.move_toward(Vector2(1.0, 1.0), _sp);
		
	var _blur = get_node("Blur") as ColorRect;
	#_blur.material.set("shader_parameter/LOD", 1.0 + sin(Time.get_ticks_msec() / 1000.0));
	_blur.modulate.a = 0.50 + sin(Time.get_ticks_msec() / 1000.0) * 0.50;
	
func addPlayer():
	var _player = playerIconScene.instantiate()
	playersNode.add_child(_player);

func pulsePlayer(playerInd) -> void:
	var _playerIcon = playersNode.get_child(playerInd) as TextureRect;
	_playerIcon.scale = Vector2(1.10, 1.10);

func showMessage(message: String) -> void:
	var _msg = messageScene.instantiate();
	_msg.position = Vector2.ZERO;
	_msg.text = message;
	messagesSpace.add_child(_msg);
	
