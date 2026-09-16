extends Node2D
## Root of the game: persists across region swaps. Registers Player + the
## World container with GameManager, then loads the starting region.

@export var starting_region: String = "res://world/Solenne/Foret_Aube/foret_aube.tscn"

@onready var world: Node2D = $World
@onready var player: Player = $Player


func _ready() -> void:
	GameManager.register_world(world, player)
	GameManager.change_region(starting_region)
