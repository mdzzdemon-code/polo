extends Node
## Finds the closest Interactable in front of the player each frame and lets
## the player trigger it with E. Drives the "[E] ..." HUD prompt.

signal focus_changed(interactable: Node)

@export var interact_range: float = 3.0
@export var interact_cone_dot: float = 0.4 # how forward-facing a target must be

@onready var player: CharacterBody3D = get_parent()

var current_focus: Node = null
var _was_key_down: bool = false


func _physics_process(_delta: float) -> void:
	var best: Node = null
	var best_dist := INF
	for interactable in get_tree().get_nodes_in_group("interactable"):
		if not is_instance_valid(interactable):
			continue
		var to_target: Vector3 = interactable.global_position - player.global_position
		var dist := to_target.length()
		if dist > interact_range:
			continue
		var flat := Vector3(to_target.x, 0.0, to_target.z).normalized()
		# BodyMesh yaw follows movement.gd's atan2(x, z) convention.
		var yaw: float = player.get_node("BodyMesh").rotation.y
		var facing := Vector3(sin(yaw), 0.0, cos(yaw))
		if flat.dot(facing) < interact_cone_dot and dist > 1.0:
			continue
		if dist < best_dist:
			best_dist = dist
			best = interactable

	if best != current_focus:
		current_focus = best
		focus_changed.emit(current_focus)

	var key_down := Input.is_physical_key_pressed(KEY_E)
	if key_down and not _was_key_down and current_focus != null:
		if current_focus.has_method("interact"):
			current_focus.interact(player)
	_was_key_down = key_down
