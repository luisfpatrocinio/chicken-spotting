extends CanvasLayer

@onready var rect: ColorRect = get_node("ColorRect");
var progress: float = 1.0;

func _ready():
	visible = true;

func _process(delta):
	progress = move_toward(progress, 0.0, 0.069 / 4);
	rect.color.a = progress;
	#rect.modulate.a = 0;
	Crtfx.get_node("CRTFX").material.set("shader_parameter/noise_amount", progress  * 1.0);

	if progress <= 0.0:
		queue_free();
