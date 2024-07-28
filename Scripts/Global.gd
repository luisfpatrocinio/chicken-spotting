extends Node
@onready var sfxPlayer : AudioStreamPlayer = get_node("SFXPlayer");
@onready var bgmPlayer : AudioStreamPlayer = get_node("BGMPlayer");
@export var transitionScene: PackedScene = preload("res://Scenes/transition_fade_in.tscn");
var numberOfPlayers: int = 1;
var levelRef: Level = null;

var scenesDict: Dictionary = {
	"title": preload("res://Scenes/title_screen.tscn"),
	"game": preload("res://Scenes/level.tscn")
}

var musicsDict: Dictionary = {
	"title": preload("res://Assets/Chicken Spotting.mp3"),	
	"game": preload("res://Assets/Marching Monsters.mp3")
}

var soundsDict: Dictionary = {
	"count": preload("res://Assets/Coin 2.wav"),
	"start": preload("res://Assets/Coin Total Win 2.wav")
}

func playSFX(sfxKey: String, randomPitch: bool = false) -> void:
	var _soundToPlay = soundsDict.get(sfxKey);
	if _soundToPlay != null: 
		sfxPlayer.stream = _soundToPlay;
		if randomPitch: sfxPlayer.pitch_scale = randf_range(0.90, 1.10);
		sfxPlayer.play();
	
func playBGM(bgmKey: String) -> void:
	var _musicToPlay = musicsDict.get(bgmKey);
	if _musicToPlay != null: 
		bgmPlayer.stream = _musicToPlay;
		bgmPlayer.play();

func transitionToScene(destinyScene: String):
	var _scene = Global.scenesDict.get(destinyScene);
	var _trans = transitionScene.instantiate();
	_trans.destinyScene = _scene;
	add_child(_trans);
