extends Node
## Owns the game's top-level state: current scene, current mode (exploration / combat / dialogue).

enum Mode { EXPLORATION, COMBAT, DIALOGUE, CUTSCENE, MENU }

var current_mode: Mode = Mode.EXPLORATION
var current_scene_path: String = ""


func set_mode(mode: Mode) -> void:
	current_mode = mode


func change_scene(scene_path: String) -> void:
	current_scene_path = scene_path
	get_tree().change_scene_to_file(scene_path)
