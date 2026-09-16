extends Node
## Finds the closest Interactable in front of the player each frame and lets
## the player trigger it with E. Drives the "[E] ..." HUD prompt.

signal focus_changed(interactable: Node)

@export var interact_range: float = 120.0
@export var interact_cone_dot: float = 0.4 # how forward-facing a target must be

@onready var player: Player = get_parent()
@onready var body_visual: Node2D = player.get_node("BodyVisual")

var current_focus: Node = null
var _was_key_down: bool = false


func _physics_process(_delta: float) -> void:
	var mode := GameManager.current_mode
	if mode == GameManager.Mode.DIALOGUE or mode == GameManager.Mode.MENU or mode == GameManager.Mode.CUTSCENE:
		if current_focus != null:
			current_focus = null
			focus_changed.emit(null)
		return

	var best: Node = null
	var best_dist := INF
	var facing := Vector2.RIGHT.rotated(body_visual.rotation)
	for interactable in get_tree().get_nodes_in_group("interactable"):
		if not is_instance_valid(interactable):
			continue
		var to_target: Vector2 = interactable.global_position - player.global_position
		var dist := to_target.length()
		if dist > interact_range:
			continue
		if dist > 20.0 and to_target.normalized().dot(facing) < interact_cone_dot:
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
			AudioManager.play_sfx("interact")
			current_focus.interact(player)
	_was_key_down = key_down
