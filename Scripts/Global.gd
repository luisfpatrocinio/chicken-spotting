extends Node
@onready var sfxPlayer : AudioStreamPlayer = get_node("SFXPlayer");
@onready var bgmPlayer : AudioStreamPlayer = get_node("BGMPlayer");

var musicsDict: Dictionary = {
	"title": preload("res://Assets/Chicken Spotting.mp3"),
	"game": preload("res://Assets/Marching Monsters.mp3")
}

var soundsDict: Dictionary = {
	"count": preload("res://Assets/Coin 2.wav")
}

func playSFX(sfxKey: String) -> void:
	var _soundToPlay = soundsDict.get(sfxKey);
	if _soundToPlay != null: 
		sfxPlayer.stream = _soundToPlay;
		sfxPlayer.play();
	
func playBGM(bgmKey: String) -> void:
	var _musicToPlay = musicsDict.get(bgmKey);
	if _musicToPlay != null: 
		bgmPlayer.stream = _musicToPlay;
		bgmPlayer.play();
