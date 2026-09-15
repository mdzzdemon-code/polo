extends Node
## Autoload. Thin wrapper around the Music/Ambience/SFX/Voice buses so gameplay
## code never touches AudioStreamPlayer nodes directly.

var _sfx_player: AudioStreamPlayer
var _music_player: AudioStreamPlayer
var _ambience_player: AudioStreamPlayer
var _sfx_cache: Dictionary = {}

const SFX_DIR := "res://audio/SFX/"


func _ready() -> void:
	_sfx_player = _make_player("SFX")
	_music_player = _make_player("Music")
	_ambience_player = _make_player("Ambience")


func _make_player(bus: String) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.bus = bus if AudioServer.get_bus_index(bus) >= 0 else "Master"
	add_child(p)
	return p


func play_sfx(sfx_name: String, volume_db: float = 0.0) -> void:
	var stream: AudioStream = _load_cached(SFX_DIR + sfx_name + ".wav")
	if stream == null:
		return
	var p := AudioStreamPlayer.new()
	p.bus = _sfx_player.bus
	p.stream = stream
	p.volume_db = volume_db
	add_child(p)
	p.play()
	p.finished.connect(p.queue_free)


func play_music(track_path: String, fade_seconds: float = 1.0) -> void:
	var stream: AudioStream = _load_cached(track_path)
	if stream == null:
		return
	_music_player.stream = stream
	_music_player.volume_db = -80.0
	_music_player.play()
	var tween := create_tween()
	tween.tween_property(_music_player, "volume_db", 0.0, fade_seconds)


func stop_music(fade_seconds: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(_music_player, "volume_db", -80.0, fade_seconds)
	tween.finished.connect(_music_player.stop)


func _load_cached(path: String) -> AudioStream:
	if not ResourceLoader.exists(path):
		return null
	if not _sfx_cache.has(path):
		_sfx_cache[path] = load(path)
	return _sfx_cache[path]
