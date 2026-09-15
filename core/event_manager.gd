extends Node
## Decouples world events so systems can react without hardcoding cross-references
## (e.g. Maëlle finds the fragment -> fragment reacts -> glitch -> anomaly detected).
## Also owns the world's flag registry: the single source of truth that dialogue,
## quests, events, endings and consequences all read/write to stay decoupled.

signal world_event(event_id: StringName, payload: Dictionary)
signal flag_changed(flag: StringName, value: bool)

var _flags: Dictionary = {} # StringName -> bool


func fire(event_id: StringName, payload: Dictionary = {}) -> void:
	world_event.emit(event_id, payload)


func set_flag(flag: StringName, value: bool = true) -> void:
	if _flags.get(flag, false) == value:
		return
	_flags[flag] = value
	flag_changed.emit(flag, value)


func has_flag(flag: StringName) -> bool:
	return _flags.get(flag, false)


func has_all_flags(flags: Array[StringName]) -> bool:
	for f in flags:
		if not has_flag(f):
			return false
	return true


func has_any_flag(flags: Array[StringName]) -> bool:
	for f in flags:
		if has_flag(f):
			return true
	return false


func clear_loop_scoped_flags(prefix: StringName = &"loop/") -> void:
	# Called by LoopManager on reset: flags namespaced "loop/..." don't survive a reset,
	# everything else (discoveries, memories-related flags) does.
	var prefix_str := String(prefix)
	for key in _flags.keys().duplicate():
		if String(key).begins_with(prefix_str):
			_flags.erase(key)
