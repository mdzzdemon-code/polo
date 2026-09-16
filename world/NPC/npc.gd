extends CharacterBody2D
class_name NPC
## Generic PNJ driven by a CharacterData resource: schedule-based movement
## between in-scene Marker2D waypoints, a default dialogue plus flag-gated
## variants, and a receive_hit() so it participates in friendly fire and can
## genuinely die (see CharacterData.can_die — no plot armor).

signal died

@export var character_data: CharacterData
@export var dialogue: DialogueData
@export var dialogue_variants: Array[DialogueData] = [] # checked in order, first match wins
@export var schedule_markers: Array[NodePath] = [] # Marker2D siblings in this region
@export var schedule_hours: Array[int] = [] # start hour for each marker, same length
@export var move_speed: float = 100.0
@export var dies_on_flag: StringName # optional — a narrative consequence can kill this PNJ directly

@onready var body_visual: Node2D = $BodyVisual
var health: float
var is_dead: bool = false


func _ready() -> void:
	health = character_data.max_health if character_data else 30.0
	if character_data:
		var body_rect: ColorRect = body_visual.get_node("Body")
		body_rect.color = character_data.placeholder_color
	if dies_on_flag != &"":
		if EventManager.has_flag(dies_on_flag):
			die()
		else:
			EventManager.flag_changed.connect(_on_flag_changed)


func _on_flag_changed(flag: StringName, value: bool) -> void:
	if flag == dies_on_flag and value and not is_dead:
		die()


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	var target := _current_schedule_target()
	var vel := Vector2.ZERO
	if target:
		var to_target: Vector2 = target.global_position - global_position
		if to_target.length() > 4.0:
			var dir := to_target.normalized()
			vel = dir * move_speed
			body_visual.rotation = lerp_angle(body_visual.rotation, dir.angle(), 6.0 * delta)
	velocity = vel
	move_and_slide()


func _current_schedule_target() -> Node2D:
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
		# A PNJ death is exactly the kind of consequence that should nudge the
		# world's degradation — causality, not a scripted "day 2 = dark" flip.
		ConsequenceManager.apply("npc/%s/dead" % character_data.id, 1)
	died.emit()
	hide()
	set_physics_process(false)
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
