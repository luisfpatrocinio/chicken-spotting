extends Node3D
class_name Level

@onready var cameraNode: Node3D = get_node("CameraPivot");
@onready var spawnTimer: Timer = get_node("SpawnTimer");
@onready var chickenScene: PackedScene = preload("res://Scenes/Monsters/Chicken.tscn");
@onready var penguinScene: PackedScene = preload("res://Scenes/Monsters/Penguin.tscn");
@onready var monsterTowerScene: PackedScene = preload("res://Scenes/monster_tower.tscn");
@onready var monstersNode: Node3D = get_node("Monsters");
@onready var resultsMonstersNode: Node3D = get_node("ResultsMonsters");
@onready var countResultsTimer: Timer = get_node("CountResultsTimer");
@onready var resultsCurve : Curve = preload("res://Curves/ChickenResultsCurve.tres");
@onready var victoryCanvas: PackedScene = preload("res://Scenes/victory_canvas.tscn");
var startTimerCount : int = 3;
var createdChickens: int = 0;
var playersInputs: Dictionary = {}
@export var chickensToCreate: int = randi_range(22, 45);
var gameStarted: bool = false;
var gameFinished: bool = false;
var showingResults: bool = false;
var lastBehaviour: int = 0;
var intervalFactor: float = 1.0;
var countingVictory: bool = false;
var victoryChickenCount: int = 0;
var showVictoryScreen: bool = false;
var winners : Array[int] = [];


func _ready() -> void:
	Global.playBGM("game");
	Global.levelRef = self;
	Interface.addPlayers(); #TODO: REMOVER DEPOIS
	Interface.timeCountLabel.visible = true;
	
func startGame():
	print("Jogo iniciado.");
	gameStarted = true;
	spawnTimer.start();

func _process(delta):
	if !gameStarted:
		if Input.is_action_just_pressed("ui_accept"):
			startGame();
	
	if createdChickens >= chickensToCreate:
		spawnTimer.stop();
	
	manageGameOver();
	
	manageResults();

func _input(event) -> void:
	if gameStarted and !gameFinished and event.is_action_pressed("ui_accept"):
		playersInputs[event.device] = playersInputs.get(event.device, 0) + 1;
		Interface.pulsePlayer(event.device);
		Global.playSFX("count", true);

func spawnChicken(i = 0.0) -> void:
	var _chicken: Node = chickenScene.instantiate();
	_chicken.position = Vector3(-5.0 - i, -0.50, -1);
	_chicken.idFactor = i;
	_chicken.behaviour = lastBehaviour;
	monstersNode.add_child(_chicken);
	createdChickens += 1;
	print("Adicionado: %s. Total: %s" % [1, createdChickens]);
	
func spawnPenguin(i = 0.0) -> void:
	var _penguin: Node = penguinScene.instantiate();
	_penguin.position = Vector3(-5.0 - i, -0.50, -1);
	_penguin.idFactor = i;
	_penguin.behaviour = lastBehaviour;
	monstersNode.add_child(_penguin);

func spawnMonsterTower() -> void:
	print("Criando torre.");
	var _tower: Node = monsterTowerScene.instantiate();
	_tower.position = Vector3(-5.0, -0.50, -1);
	
	_tower.towerSize = randi_range(3, 7);
	
	var _chickenInThisTower = randi_range(2, 5);
	_chickenInThisTower = min(_chickenInThisTower, _tower.towerSize);
	_tower.chickenQnt = _chickenInThisTower;
	
	monstersNode.add_child(_tower);
	createdChickens += _chickenInThisTower;
	print("TORRE: Adicionado: %s. Total: %s" % [_chickenInThisTower, createdChickens]);

func manageGameOver():
	if gameFinished and !showingResults:
		var _lens = Interface.get_node("Binoculars") as Sprite2D
		_lens.modulate.a = move_toward(_lens.modulate.a, 0.0, 0.015);
		_lens.scale = _lens.scale.move_toward(Vector2(1.10, 1.10), 0.0025);
		
		var _tween = get_tree().create_tween();
		_tween.tween_property(cameraNode, "global_position", Vector3(0.0, 0.65, 6.50), 1.0)
		await _tween.finished;
		
		await get_tree().create_timer(3);
		showingResults = true;
	elif !showingResults:
		if createdChickens >= chickensToCreate and monstersNode.get_child_count() <= 0:
			gameFinished = true;
			Interface.showMessage("FINISH!");
			
	if showingResults and !showVictoryScreen:
		for i in range(Interface.playersNode.get_child_count()):
			var icon = Interface.playersNode.get_child(i);
			icon.get_node("Label").visible = true;
			icon.get_node("Label").text = str(playersInputs.get(i));
			
	
func _on_spawn_timer_timeout() -> void:
	spawnTimer.wait_time = randf_range(1.0, 2.0) * intervalFactor;	
	if lastBehaviour == 0 and randi() % 2 == 0:
		spawnMonsterTower();
	else:
		var _qnt = 1;
		if randi() % 3 == 0 and lastBehaviour == 0:
			print("CRIANDO VARIOS PINTOS EM SEQUENCIA");
			_qnt = randi_range(3, 5);
			spawnTimer.wait_time += _qnt * 0.150;
		
		for i in range(_qnt):
			if randi() % 4 == 0:
				spawnPenguin(i);
			else:
				spawnChicken(i);
					
	lastBehaviour = wrap(lastBehaviour + 1, 0, 3);
	#intervalFactor -= 0.01;

func animateResultChicken(no: int):
	var _chicken = resultsMonstersNode.get_child(no) as CharacterBody3D;
	var _anim = _chicken.get_node("AnimationPlayer") as AnimationPlayer;
	_anim.play("Yes")

func _on_count_results_timer_timeout():
	if victoryChickenCount < resultsMonstersNode.get_child_count():
		Interface.chickenCountLabel.visible = true;
		animateResultChicken(victoryChickenCount);
		victoryChickenCount += 1;				
		var _xPos = victoryChickenCount / float(resultsMonstersNode.get_child_count());
		countResultsTimer.wait_time = resultsCurve.sample(_xPos);
		Interface.chickenCountLabel.text = str(victoryChickenCount);
	else:
		# Instante em que para de contar os pintos.
		
		# Registra vencedor
		winners = [];
		for player in playersInputs:
			var _thisPlayerScore = playersInputs[player]
			if createdChickens == _thisPlayerScore:
				winners.append(player);
		
		# Cria tela de vitória.
		var _vic = victoryCanvas.instantiate()
		Interface.add_child(_vic);
		
		# Interrompe o tempo	
		countResultsTimer.stop();
		
		# Marca como verdadeiro essa variável de controle.
		showVictoryScreen = true;
		


func _onStartTimerTimeout():
	if startTimerCount <= 0:
		$StartTimer.stop();	
		Interface.timeCountLabel.visible = false;
		return
	startTimerCount -= 1;
	Interface.timeCountLabel.text = str(startTimerCount) if startTimerCount > 0 else "START!";
	if startTimerCount <= 0:
		startGame();

func manageResults():
	if showingResults:
		if resultsMonstersNode.get_child_count() <= 0:
			var _n = 0;
			for i in range(createdChickens):
				var _chicken = chickenScene.instantiate();
				resultsMonstersNode.add_child(_chicken);
				var _w = 10;
				var _spac = 0.850;
				_chicken.position.x = (_n % _w) * _spac;
				_chicken.position.z = floor(_n / _w) * _spac;
				_chicken.set_process(false);
				_n += 1;
		cameraNode.global_position = cameraNode.global_position.lerp(Vector3(15.0, 4.0, 6.50), 0.050);
		cameraNode.rotation.x = lerp(cameraNode.rotation.x, -0.50, 0.050)
		cameraNode.rotation.y = 0.0
		cameraNode.rotation.z = 0.0
		if countResultsTimer.is_stopped() and !showVictoryScreen: 
			countResultsTimer.start();
	
	if showVictoryScreen:
		if Input.is_action_just_pressed("ui_accept"):
			Global.transitionToScene("title");
