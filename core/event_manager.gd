extends Node
## Decouples world events so systems can react without hardcoding cross-references
## (e.g. Maëlle finds the fragment -> fragment reacts -> glitch -> anomaly detected).

signal world_event(event_id: StringName, payload: Dictionary)


func fire(event_id: StringName, payload: Dictionary = {}) -> void:
	world_event.emit(event_id, payload)
