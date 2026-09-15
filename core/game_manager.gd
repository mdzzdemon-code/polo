extends Node
## Owns the game's top-level state: current region, current mode.
## The Player and UI live outside of any region scene (see Main.tscn) so that
## swapping regions never destroys them — only the region content underneath
## world_container is replaced.

signal mode_changed(mode: Mode)
signal region_changed(region_path: String)

enum Mode { EXPLORATION, COMBAT, DIALOGUE, CUTSCENE, MENU }

var current_mode: Mode = Mode.EXPLORATION
var current_region_path: String = ""

var world_container: Node3D
var player: Player


func set_mode(mode: Mode) -> void:
	if current_mode == mode:
		return
	current_mode = mode
	mode_changed.emit(mode)


func register_world(container: Node3D, player_node: Player) -> void:
	world_container = container
	player = player_node


func change_region(scene_path: String, spawn_point: StringName = &"PlayerSpawn") -> void:
	if world_container == null:
		return
	for child in world_container.get_children():
		world_container.remove_child(child)
		child.queue_free()
	var region_scene: PackedScene = load(scene_path)
	var region: Node = region_scene.instantiate()
	world_container.add_child(region)
	current_region_path = scene_path
	var spawn: Node3D = region.get_node_or_null(String(spawn_point))
	if spawn and player:
		player.global_position = spawn.global_position
		player.rotation.y = spawn.rotation.y
	region_changed.emit(scene_path)
