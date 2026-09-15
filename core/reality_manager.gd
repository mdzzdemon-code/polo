extends Node
## Central authority for the paradox's rules: glitches, contradictions, degradation level, corrections.

signal glitch_triggered(glitch_id: StringName)
signal degradation_level_changed(level: int)

var degradation_level: int = 0
var active_glitches: Array[StringName] = []


func trigger_glitch(glitch_id: StringName) -> void:
	active_glitches.append(glitch_id)
	glitch_triggered.emit(glitch_id)


func increase_degradation(amount: int = 1) -> void:
	degradation_level += amount
	degradation_level_changed.emit(degradation_level)
