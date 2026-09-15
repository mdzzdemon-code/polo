extends CharacterBody3D
class_name Trauma
## Physical manifestation of a psychological wound, driven by a TraumaData
## resource. Simple patrol/chase/attack/staggered state machine. When
## SynapseLink has "read" the player's dodge habit against this Trauma id,
## its attacks bypass the player's dodge i-frames — the fight is won by
## breaking the pattern, not by better stats.

signal died

@export var trauma_data: TraumaData
@export var home_path: NodePath # optional patrol anchor; defaults to spawn position

@onready var body_mesh: Node3D = $BodyMesh
@onready var stability: StabilityComponent = $Stability

var health: float
var state: String = "patrol" # patrol | chase | attack | staggered
var _home: Vector3
var _attack_cooldown: float = 0.0
var _stagger_timer: float = 0.0
var gravity: float = 18.0


func _ready() -> void:
	add_to_group("trauma")
	add_to_group("damageable")
	health = trauma_data.max_health if trauma_data else 60.0
	stability.max_stability = trauma_data.max_stability if trauma_data else 50.0
	stability.current_stability = stability.max_stability
	stability.broken.connect(_on_stability_broken)
	_home = get_node(home_path).global_position if home_path != NodePath() else global_position
	if trauma_data:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = trauma_data.placeholder_color
		body_mesh.get_node("MeshInstance3D").set_surface_override_material(0, mat)


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
		_apply_gravity(delta)
		move_and_slide()
		return

	var player: Player = GameManager.player
	var vel := velocity
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
			var dir := (player.global_position - global_position)
			dir.y = 0.0
			dir = dir.normalized()
			vel.x = dir.x * trauma_data.move_speed
			vel.z = dir.z * trauma_data.move_speed
			body_mesh.rotation.y = lerp_angle(body_mesh.rotation.y, atan2(dir.x, dir.z), 6.0 * delta)
		elif state == "attack":
			vel.x = 0.0
			vel.z = 0.0
			var dir := (player.global_position - global_position)
			dir.y = 0.0
			if dir.length() > 0.01:
				body_mesh.rotation.y = lerp_angle(body_mesh.rotation.y, atan2(dir.x, dir.z), 6.0 * delta)
			if _attack_cooldown <= 0.0:
				_perform_attack(player)
				_attack_cooldown = 1.6
		else:
			_patrol(delta, vel)
	else:
		vel.x = 0.0
		vel.z = 0.0

	velocity = vel
	_apply_gravity(delta)
	move_and_slide()


func _patrol(_delta: float, vel: Vector3) -> void:
	var to_home := _home - global_position
	to_home.y = 0.0
	if to_home.length() > 1.0:
		var dir := to_home.normalized()
		vel.x = dir.x * trauma_data.move_speed * 0.4
		vel.z = dir.z * trauma_data.move_speed * 0.4
	else:
		vel.x = 0.0
		vel.z = 0.0
	velocity = vel


func _apply_gravity(delta: float) -> void:
	var vel := velocity
	if is_on_floor():
		vel.y = -0.5
	else:
		vel.y -= gravity * delta
	velocity = vel


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
		var away := (global_position - target.global_position)
		away.y = 0.0
		away = away.normalized()
		velocity.x = away.x * trauma_data.move_speed * 1.5
		velocity.z = away.z * trauma_data.move_speed * 1.5


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
		if child is CollisionShape3D:
			child.set_deferred("disabled", true)
	queue_free()
