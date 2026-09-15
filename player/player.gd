extends CharacterBody3D
class_name Player
## Root controller: owns health and wires together the component nodes
## (Movement, Interaction, Combat, Inventory, Keywords, Abilities, Stability).

signal health_changed(current: float, max_health: float)
signal died

@export var max_health: float = 100.0

var health: float

@onready var movement: Node = $Movement
@onready var interaction_component: Node = $Interaction
@onready var combat: Node = $Combat
@onready var inventory: Node = $Inventory
@onready var keywords: Node = $Keywords
@onready var abilities: Node = $Abilities
@onready var stability: StabilityComponent = $Stability
@onready var camera: Camera3D = $CameraRig/SpringArm/Camera3D


func _ready() -> void:
	health = max_health
	stability.broken.connect(_on_stability_broken)


func take_damage(amount: float, _attacker: Node = null) -> void:
	health = max(0.0, health - amount)
	health_changed.emit(health, max_health)
	if health <= 0.0:
		die()


func heal(amount: float) -> void:
	health = min(max_health, health + amount)
	health_changed.emit(health, max_health)


## Common "damageable" interface — delegates to Combat so parry/i-frame rules apply.
func receive_hit(amount: float, poise_damage: float, attacker: Node, weapon: WeaponData = null) -> void:
	combat.receive_hit(amount, poise_damage, attacker, weapon)


func die() -> void:
	died.emit()
	LoopManager.end_loop("death")


func _on_stability_broken() -> void:
	# A broken Synapse-Lien leaves the Anomaly briefly exposed to bonus damage;
	# concrete "guard break" punish is handled by whichever Trauma exploits it.
	get_tree().create_timer(2.0).timeout.connect(stability.recover_from_break)
