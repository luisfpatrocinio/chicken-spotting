extends CSGBox3D
@export var speed: float = 0.10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_parent().currentDisplay != 3:
		global_position.x -= speed;
		if global_position.x < -15.0:
			global_position.x += 30.0 + randf_range(0.0, 2.0);
			global_position.y += randf_range(-1.0, 1.0);
			global_position.y = clamp(global_position.y, 0.0, 3.0);
