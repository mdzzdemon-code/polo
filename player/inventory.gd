extends Node
## Simple stack-based inventory. Items are ItemData resources; most do NOT
## persist across loops (see item.persists_across_loops) — only memories do.

signal item_added(item: ItemData, quantity: int)
signal item_removed(item: ItemData, quantity: int)

var slots: Dictionary = {} # StringName(item.id) -> {"item": ItemData, "quantity": int}


func add_item(item: ItemData, quantity: int = 1) -> void:
	if item.stackable and slots.has(item.id):
		slots[item.id].quantity += quantity
	else:
		slots[item.id] = {"item": item, "quantity": quantity}
	item_added.emit(item, quantity)


func remove_item(item_id: StringName, quantity: int = 1) -> void:
	if not slots.has(item_id):
		return
	var entry: Dictionary = slots[item_id]
	entry.quantity -= quantity
	if entry.quantity <= 0:
		var item: ItemData = entry.item
		slots.erase(item_id)
		item_removed.emit(item, quantity)
	else:
		item_removed.emit(entry.item, quantity)


func has_item(item_id: StringName) -> bool:
	return slots.has(item_id)


func clear_loop_scoped_items() -> void:
	# Called by LoopManager on reset: equipment/consumables reset, key persistent
	# items (item.persists_across_loops) survive — this is the "no snowballing gear" rule.
	for key in slots.keys().duplicate():
		var entry: Dictionary = slots[key]
		if not entry.item.persists_across_loops:
			slots.erase(key)
