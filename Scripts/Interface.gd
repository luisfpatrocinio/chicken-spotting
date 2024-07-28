extends CanvasLayer

@onready var playerIconScene: PackedScene = preload("res://Scenes/interfacePlayerIcon.tscn")
@onready var playersNode: HBoxContainer = get_node("Players/HBoxContainer");
@onready var chickenCountLabel: Label = get_node("ChickenCountLabel");
@onready var timeCountLabel: Label = get_node("TimeCount");
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
	
func addPlayers():
	for i in range(max(1, len(Input.get_connected_joypads()))):
		var _player = playerIconScene.instantiate()
		playersNode.add_child(_player);
		Global.levelRef.playersInputs[i] = 0;
		#TODO: Conferir se todos os inputs obedecem essa ordem.

func pulsePlayer(playerInd) -> void:
	var _playerIcon = playersNode.get_child(playerInd) as TextureRect;
	if _playerIcon != null:
		_playerIcon.scale = Vector2(1.10, 1.10);

func showMessage(message: String) -> void:
	var _msg = messageScene.instantiate();
	_msg.position = Vector2.ZERO;
	_msg.text = message;
	messagesSpace.add_child(_msg);
	
func resetInterface() -> void:
	# Deletar todos os filhos de playersNode:
	for player in playersNode.get_children():
		player.queue_free();
	
	# Deletar Victory Canvas
	var _victory = get_node_or_null("VictoryCanvas");
	if _victory:
		_victory.queue_free();

	# Tornar invisível novamente as labels
	chickenCountLabel.visible = false;
	timeCountLabel.visible = false;
	$Binoculars.modulate.a = 169.0 / 255.0;
