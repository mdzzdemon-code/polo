extends CharacterBody3D
class_name NPC
## Generic PNJ driven by a CharacterData resource: schedule-based movement
## between in-scene Marker3D waypoints, a default dialogue plus flag-gated
## variants, and a receive_hit() so it participates in friendly fire and can
## genuinely die (see CharacterData.can_die — no plot armor).

signal died

@export var character_data: CharacterData
@export var dialogue: DialogueData
@export var dialogue_variants: Array[DialogueData] = [] # checked in order, first match wins
@export var schedule_markers: Array[NodePath] = [] # Marker3D siblings in this region
@export var schedule_hours: Array[int] = [] # start hour for each marker, same length
@export var move_speed: float = 2.5
@export var gravity: float = 18.0

@onready var body_mesh: Node3D = $BodyMesh
var health: float
var is_dead: bool = false


func _ready() -> void:
	health = character_data.max_health if character_data else 30.0
	if character_data:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = character_data.placeholder_color
		var mesh_instance: MeshInstance3D = body_mesh.get_node("MeshInstance3D")
		mesh_instance.set_surface_override_material(0, mat)


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	var target := _current_schedule_target()
	var vel := velocity
	if target:
		var to_target: Vector3 = target.global_position - global_position
		to_target.y = 0.0
		if to_target.length() > 0.3:
			var dir := to_target.normalized()
			vel.x = dir.x * move_speed
			vel.z = dir.z * move_speed
			body_mesh.rotation.y = lerp_angle(body_mesh.rotation.y, atan2(dir.x, dir.z), 6.0 * delta)
		else:
			vel.x = 0.0
			vel.z = 0.0
	else:
		vel.x = 0.0
		vel.z = 0.0

	if is_on_floor():
		vel.y = -0.5
	else:
		vel.y -= gravity * delta
	velocity = vel
	move_and_slide()


func _current_schedule_target() -> Node3D:
	if schedule_markers.is_empty():
		return null
	var hour := TimeManager.hour()
	var best_index := 0
	var best_hour := -1
	for i in schedule_hours.size():
		if schedule_hours[i] <= hour and schedule_hours[i] > best_hour:
			best_hour = schedule_hours[i]
			best_index = i
	if best_index >= schedule_markers.size():
		return null
	return get_node_or_null(schedule_markers[best_index])


func start_dialogue(_player: Player) -> void:
	if is_dead:
		return
	var chosen: DialogueData = dialogue
	for variant in dialogue_variants:
		if EventManager.has_all_flags(variant.required_flags) and not EventManager.has_any_flag(variant.forbidden_flags):
			chosen = variant
			break
	if chosen:
		DialogueManager.start_dialogue(chosen)


## Common "damageable" interface — makes friendly fire and PNJ death possible.
func receive_hit(amount: float, _poise_damage: float, _attacker: Node, _weapon: WeaponData = null) -> void:
	if is_dead or not (character_data == null or character_data.can_die):
		return
	health = max(0.0, health - amount)
	if health <= 0.0:
		die()


func die() -> void:
	is_dead = true
	if character_data:
		ConsequenceManager.apply("npc/%s/dead" % character_data.id)
	died.emit()
	hide()
	set_physics_process(false)
	for child in get_children():
		if child is CollisionShape3D:
			child.set_deferred("disabled", true)
