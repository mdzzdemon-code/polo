extends Resource
class_name CharacterData
## Data template for a character, kept separate from behavior scripts so content
## (Maëlle, Tom, Romain, ...) can be authored as .tres resources instead of code.

@export var character_name: String
@export var age: int
@export var personality: String
@export var schedule: Array[Dictionary] = [] # [{hour, location, activity}, ...]
@export var memories: Array[StringName] = []
@export var relationships: Dictionary = {} # character_id -> relationship value/state
@export var dialogue_tree_path: String
@export var quest_ids: Array[StringName] = []
@export var death_conditions: Array[Dictionary] = []
@export var loop_state: Dictionary = {} # per-loop overrides (position, alive, variant, ...)
