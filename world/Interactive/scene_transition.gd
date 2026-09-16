extends Area2D
class_name SceneTransition
## A trigger volume that swaps the active region when the player walks through it.

@export var target_scene_path: String
@export var target_spawn_point: StringName = &"PlayerSpawn"


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and target_scene_path != "":
		GameManager.change_region(target_scene_path, target_spawn_point)
