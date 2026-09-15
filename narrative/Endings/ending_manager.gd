extends Node
## Autoload. Evaluates registered EndingData in priority order and reports the
## first one whose conditions are satisfied.

signal ending_reached(ending: EndingData)

var all_endings: Array[EndingData] = []
var ending_locked: bool = false


func _ready() -> void:
	EventManager.flag_changed.connect(func(_f, _v): trigger_if_ready())


func register_ending(ending: EndingData) -> void:
	all_endings.append(ending)
	all_endings.sort_custom(func(a, b): return a.priority > b.priority)


func evaluate() -> EndingData:
	for ending in all_endings:
		if EventManager.has_all_flags(ending.required_flags) and not EventManager.has_any_flag(ending.forbidden_flags):
			return ending
	return null


func trigger_if_ready() -> bool:
	if ending_locked:
		return false
	var ending := evaluate()
	if ending:
		ending_locked = true
		ending_reached.emit(ending)
		SaveManager.save_game()
		return true
	return false
