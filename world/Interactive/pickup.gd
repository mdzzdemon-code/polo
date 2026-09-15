extends Interactable
class_name Pickup
## A world item the player can pick up. Since it's part of the region scene,
## it naturally "respawns" whenever the region reloads on a new loop.

@export var item: ItemData
@export var quantity: int = 1
@export var sets_flag_on_pickup: StringName # optional, for fetch-quest hooks


func _ready() -> void:
	super._ready()
	prompt_text = "Ramasser " + (item.display_name if item else "?")


func interact(player: Player) -> void:
	if item == null:
		return
	player.inventory.add_item(item, quantity)
	AudioManager.play_sfx("pickup")
	EventManager.fire("item_picked_up", {"item_id": item.id})
	if sets_flag_on_pickup != &"":
		EventManager.set_flag(sets_flag_on_pickup)
	hide()
	set_deferred("monitoring", false)
	queue_free()
