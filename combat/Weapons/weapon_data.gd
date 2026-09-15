extends Resource
class_name WeaponData
## Data template for a weapon (armes rapides / lourdes / à distance).

enum Category { FAST, HEAVY, RANGED }

@export var id: StringName
@export var display_name: String
@export var category: Category = Category.FAST
@export var damage: float = 10.0
@export var attack_speed: float = 1.0 # attacks per second
@export var stamina_cost: float = 15.0
@export var range: float = 2.0
@export var poise_damage: float = 10.0 # stability damage dealt on hit
@export var can_be_parried: bool = true
@export var placeholder_color: Color = Color.WHITE
@export_multiline var description: String
