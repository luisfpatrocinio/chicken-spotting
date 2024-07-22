extends Node
@onready var sfxPlayer : AudioStreamPlayer = get_node("SFXPlayer");

var soundsDict: Dictionary = {
	"count": preload("res://Assets/Coin 2.wav")
}

func playSFX(sfxKey: String) -> void:
	var _soundToPlay = soundsDict.get(sfxKey);
	if _soundToPlay != null: 
		sfxPlayer.stream = _soundToPlay;
		sfxPlayer.play();
	
