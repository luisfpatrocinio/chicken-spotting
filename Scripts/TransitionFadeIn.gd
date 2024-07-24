extends CanvasLayer

var destinyScene: PackedScene = null;
@onready var rect: ColorRect = get_node("ColorRect");
var progress: float = 0.0;

func _process(delta):
	progress = move_toward(progress, 1.0, 0.069 / 4);
	rect.color.a = progress;
	#rect.modulate.a = 0.0;
	Crtfx.get_node("CRTFX").material.set("shader_parameter/noise_amount", progress  * 1.0);
	
		

	if destinyScene != null:
		if progress >= 1.0:
			await get_tree().create_timer(1).timeout;
			get_tree().change_scene_to_packed(destinyScene);
			queue_free();
