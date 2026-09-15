extends Resource
class_name ItemData
## Generic inventory item (weapon, key item, fragment, consumable...).

enum Kind { WEAPON, KEY_ITEM, FRAGMENT, CONSUMABLE }

@export var id: StringName
@export var display_name: String
@export var kind: Kind = Kind.KEY_ITEM
@export var stackable: bool = false
@export var persists_across_loops: bool = false # most items don't; memories do instead
@export var linked_weapon: WeaponData
@export var placeholder_color: Color = Color.GOLDENROD
@export_multiline var description: String
