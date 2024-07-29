extends CharacterBody3D
class_name MonsterTower

@export var monsterArray = [];
@export var towerSize : int = 0;
@export var chickenQnt : int = 0;
var chickens: int = 0;
@export var chickenScene: PackedScene = preload("res://Scenes/Monsters/Chicken.tscn");
@export var penguinScene: PackedScene = preload("res://Scenes/Monsters/Penguin.tscn");

var canDestroy = false;

func _ready():
	var _towerArray = []; # Array compostos por 0 caso penguin ou 1 caso chicken
	var _initializedChickens = 0;
	# Garantir que _towerArray tenha pelo menos chickenQnt vezes o valor 1, e o restante 0
	for i in range(chickenQnt):
		_towerArray.append(1)
	
	for i in range(towerSize - chickenQnt):
		_towerArray.append(0)
	
	# Embaralhar o array para que a ordem dos elementos seja aleatória
	_towerArray.shuffle()
		
	var _carryRef = null;
	for i in range(towerSize):
		var _isChicken = _towerArray[i] == 1;
		var _monster = chickenScene.instantiate() if _isChicken else penguinScene.instantiate();
		add_child(_monster);
		_monster.position.y = 0.60 * i;
		_monster.behaviour = 0;
		_monster.carriedBy = _carryRef;
		if i != 0: 
			_monster.beingCarried = true;
		if _carryRef == null:
			_carryRef = _monster;
		#if i != 0: _monster.set_process(false);
		canDestroy = true;

func _process(delta) -> void:
	if get_child_count() <= 0 and canDestroy:
		queue_free();
