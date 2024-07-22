extends CharacterBody3D
class_name Monster

@onready var myAnim : AnimationPlayer = get_node("AnimationPlayer");
var idFactor = 0.0;
var speed: float = 1.0;
var behaviour: int = randi() % 4;
var dancing: bool = false;
@onready var startDanceTimer : Timer = get_node("StartDanceTimer");
@onready var danceTimer : Timer = get_node("DanceTimer");
var direction: Vector3 = Vector3.RIGHT;

var beingCarried: bool = false;
var carriedBy: Monster = null;

var initialized: bool = false;

# Comportamento 0 = Caminhar até o fim
# Comportamento 1 = Correr até o fim
# Comportamento 2 = Corre até metade, dança, corre
# Comportamento 3 = Pilha de Chickens

func _ready() -> void:
	print("Pinto %s - Behaviour: %s" % [name, behaviour])
	pass

func _process(delta: float) -> void:
	initialize();
	if !beingCarried:
		if !dancing:
			velocity.x = speed;
			myAnim.speed_scale = speed * 0.75;
			if global_position.x >= 5.0:
				queue_free();
		else:
			velocity = Vector3.ZERO;
	else:
		if is_instance_valid(carriedBy):
			global_position.x = carriedBy.global_position.x;
		else:
			queue_free();
		
	move_and_slide();
	manageDirection();
	manageAnimation();
	
func initialize():
	if !initialized:
		if !beingCarried:
			match behaviour:
				0:
					speed = 1.0;
				1: 
					speed = 3.0;
					position.z = -3.0;
				2:
					print("É UM DANÇARINO")
					speed = 1.0 + randf_range(0.0, 0.50);
					position.z = 0.0;
					startDanceTimer.start(3.50);
			initialized = true;

func manageAnimation() -> void:
	if beingCarried:
		myAnim.stop();
		return;
		
	if dancing:
		myAnim.play("Dance");
	else:
		myAnim.play("Walk");
	

func manageDirection() -> void: 
	var directionTo: Vector3 = Vector3.RIGHT;
	if dancing: directionTo = Vector3.DOWN;
	
	var angle: float = atan2(directionTo.x, directionTo.z);
	rotation.y = move_toward(rotation.y, angle, 0.069);


func _onStartDanceTimerTimeout() -> void:
	print("HORA DA DANÇA");
	dancing = true;
	danceTimer.start(randf_range(1.0, 2.50));

func _onDanceTimerTimeout() -> void:
	dancing = false;
