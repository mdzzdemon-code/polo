extends CharacterBody2D
class_name Trauma
## Physical manifestation of a psychological wound, driven by a TraumaData
## resource. Simple patrol/chase/attack/staggered state machine. When
## SynapseLink has "read" the player's dodge habit against this Trauma id,
## its attacks bypass the player's dodge i-frames — the fight is won by
## breaking the pattern, not by better stats.

signal died

@export var trauma_data: TraumaData
@export var home_path: NodePath # optional patrol anchor; defaults to spawn position

@onready var body_visual: Node2D = $BodyVisual
@onready var stability: StabilityComponent = $Stability

var health: float
var state: String = "patrol" # patrol | chase | attack | staggered
var _home: Vector2
var _attack_cooldown: float = 0.0
var _stagger_timer: float = 0.0


func _ready() -> void:
	add_to_group("trauma")
	add_to_group("damageable")
	health = trauma_data.max_health if trauma_data else 60.0
	stability.max_stability = trauma_data.max_stability if trauma_data else 50.0
	stability.current_stability = stability.max_stability
	stability.broken.connect(_on_stability_broken)
	_home = get_node(home_path).global_position if home_path != NodePath() else global_position
	if trauma_data:
		var body_rect: ColorRect = body_visual.get_node("Body")
		body_rect.color = trauma_data.placeholder_color


func get_trauma_id() -> StringName:
	return trauma_data.id if trauma_data else &""


func get_weakness_tags() -> Array[StringName]:
	return trauma_data.weaknesses if trauma_data else []


func _physics_process(delta: float) -> void:
	if health <= 0.0:
		return
	_attack_cooldown = max(0.0, _attack_cooldown - delta)
	if state == "staggered":
		_stagger_timer -= delta
		if _stagger_timer <= 0.0:
			state = "patrol"
			stability.recover_from_break()
		move_and_slide()
		return

	var player: Player = GameManager.player
	var vel := Vector2.ZERO
	if player and is_instance_valid(player):
		var dist := global_position.distance_to(player.global_position)
		# SENTINEL traumas barely react until the player is right on top of them;
		# every other behavior uses the full detection_range to give chase.
		var effective_detection := trauma_data.detection_range
		if trauma_data.behavior == TraumaData.Behavior.SENTINEL:
			effective_detection = trauma_data.attack_range * 1.1
		if dist <= trauma_data.attack_range:
			state = "attack"
		elif dist <= effective_detection:
			state = "chase"
		elif state != "patrol":
			state = "patrol"

		if state == "chase":
			var dir := (player.global_position - global_position).normalized()
			vel = dir * trauma_data.move_speed
			body_visual.rotation = lerp_angle(body_visual.rotation, dir.angle(), 6.0 * delta)
		elif state == "attack":
			var dir := (player.global_position - global_position)
			if dir.length() > 0.01:
				body_visual.rotation = lerp_angle(body_visual.rotation, dir.angle(), 6.0 * delta)
			if _attack_cooldown <= 0.0:
				_perform_attack(player)
				_attack_cooldown = 1.6
		else:
			vel = _patrol_velocity()

	velocity = vel
	move_and_slide()


func _patrol_velocity() -> Vector2:
	var to_home := _home - global_position
	if to_home.length() > 4.0:
		return to_home.normalized() * trauma_data.move_speed * 0.4
	return Vector2.ZERO


func _perform_attack(target: Player) -> void:
	var predicted := SynapseLink.predicted_direction(get_trauma_id())
	if predicted != "":
		# The Trauma has learned the player's habit: this hit lands regardless
		# of dodge i-frames — breaking the pattern is the only real counter.
		target.take_damage(trauma_data.attack_damage, self)
		target.stability.damage(trauma_data.attack_damage * 0.5)
	else:
		target.receive_hit(trauma_data.attack_damage, trauma_data.attack_damage * 0.5, self)

	if trauma_data.behavior == TraumaData.Behavior.SKITTISH:
		# Skittish traumas strike and immediately put distance back between
		# themselves and the player, instead of staying in a brawl.
		var away := (global_position - target.global_position).normalized()
		velocity = away * trauma_data.move_speed * 1.5


## Common "damageable" interface.
func receive_hit(amount: float, poise_damage: float, _attacker: Node, _weapon: WeaponData = null) -> void:
	if health <= 0.0:
		return
	health = max(0.0, health - amount)
	stability.damage(poise_damage)
	if health <= 0.0:
		die()


func _on_stability_broken() -> void:
	state = "staggered"
	_stagger_timer = 3.0


func die() -> void:
	if trauma_data:
		ConsequenceManager.apply("trauma/%s/defeated" % trauma_data.id)
	died.emit()
	set_physics_process(false)
	hide()
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	queue_free()
