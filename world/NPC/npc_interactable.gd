extends Interactable
class_name NPCInteractable
## Sits as a child Area2D on an NPC so the player's generic Interaction
## component can find it in the "interactable" group and start dialogue.

@export var npc_path: NodePath = ".."


func _ready() -> void:
	super._ready()
	var npc: NPC = get_node(npc_path)
	prompt_text = "Parler à " + (npc.character_data.character_name if npc and npc.character_data else "?")


func interact(player: Player) -> void:
	var npc: NPC = get_node(npc_path)
	if npc:
		npc.start_dialogue(player)
