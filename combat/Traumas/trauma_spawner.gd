extends Node3D
## Flag-gated Trauma placement: nothing spawns until required_flags are met,
## so appearances stay tied to world/event state rather than being arbitrary
## (GDD §15 — "ils ne doivent donc pas apparaître arbitrairement partout").

const TRAUMA_SCENE := preload("res://combat/Traumas/trauma.tscn")

@export var trauma_data: TraumaData
@export var required_flags: Array[StringName] = []
@export var forbidden_flags: Array[StringName] = []

var _spawned: Node = null


func _ready() -> void:
	EventManager.flag_changed.connect(func(_f, _v): _check())
	call_deferred("_check") # avoid add_child while the region is still assembling its tree


func _check() -> void:
	if _spawned != null and is_instance_valid(_spawned):
		return
	if EventManager.has_all_flags(required_flags) and not EventManager.has_any_flag(forbidden_flags):
		_spawn()


func _spawn() -> void:
	var trauma: Node3D = TRAUMA_SCENE.instantiate()
	trauma.trauma_data = trauma_data
	# Copy the LOCAL transform (spawner and trauma share the same parent) —
	# global_position can't be read/written before the node is in the tree,
	# and add_child itself has to be deferred too (may run while the region
	# is still assembling its own children).
	trauma.transform = transform
	get_parent().add_child.call_deferred(trauma)
	_spawned = trauma
