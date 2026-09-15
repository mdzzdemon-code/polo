extends Node
class_name StabilityComponent
## Reusable "poise" meter shared by the player and Traumas: the Synapse-Lien
## mechanic breaks it to stagger a target, rather than combat being pure HP race.

signal broken
signal changed(current: float, max: float)

@export var max_stability: float = 50.0
@export var regen_per_second: float = 5.0
@export var regen_delay: float = 2.5

var current_stability: float
var _time_since_hit: float = 0.0
var is_broken: bool = false


func _ready() -> void:
	current_stability = max_stability


func _process(delta: float) -> void:
	if is_broken:
		return
	_time_since_hit += delta
	if _time_since_hit >= regen_delay and current_stability < max_stability:
		current_stability = min(max_stability, current_stability + regen_per_second * delta)
		changed.emit(current_stability, max_stability)


func damage(amount: float) -> void:
	if is_broken:
		return
	_time_since_hit = 0.0
	current_stability = max(0.0, current_stability - amount)
	changed.emit(current_stability, max_stability)
	if current_stability <= 0.0:
		is_broken = true
		broken.emit()


func recover_from_break() -> void:
	is_broken = false
	current_stability = max_stability * 0.5
	changed.emit(current_stability, max_stability)
