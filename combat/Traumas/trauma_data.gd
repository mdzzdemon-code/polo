extends Resource
class_name TraumaData
## Data template for a Trauma (physical manifestation of a psychological wound).

enum Behavior { AGGRESSIVE, SKITTISH, SENTINEL }

@export var id: StringName
@export var display_name: String
@export_multiline var symbolism: String
@export var max_health: float = 60.0
@export var max_stability: float = 50.0 # Synapse-Lien "poise" — breaking it staggers the Trauma
@export var move_speed: float = 3.0
@export var attack_damage: float = 8.0
@export var attack_range: float = 2.0
@export var detection_range: float = 10.0
@export var behavior: Behavior = Behavior.AGGRESSIVE
@export var weaknesses: Array[StringName] = [] # KeywordData ids that are super-effective
@export var placeholder_color: Color = Color.CRIMSON
@export var spawn_condition_tag: StringName # ties appearance to a RealityManager/quest state
