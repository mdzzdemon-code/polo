extends Area2D
class_name Interactable
## Base class for anything the player can press E on. Extend and override interact().

@export var prompt_text: String = "Interagir"

func _ready() -> void:
	add_to_group("interactable")


func interact(_player: Player) -> void:
	pass # override in subclasses
