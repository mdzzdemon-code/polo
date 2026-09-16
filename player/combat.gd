extends Node
## Real-time top-down combat: attack / dodge (i-frames) / parry (only effective
## against weapons flagged can_be_parried) / optional lock-on. Attacks are a
## simple range+cone check against the "damageable" group (friendly fire).
## While locked on, this component owns BodyVisual's facing instead of Movement.

signal attacked(weapon: WeaponData)
signal dodged
signal parry_attempted
signal parry_succeeded
signal lock_on_changed(target: Node)

@export var equipped_weapon: WeaponData
@export var dodge_duration: float = 0.4
@export var dodge_speed: float = 400.0
@export var dodge_iframe_time: float = 0.25
@export var parry_window: float = 0.3
@export var max_stamina: float = 100.0
@export var stamina_regen: float = 20.0
@export var attack_cone_dot: float = 0.3
@export var lock_on_range: float = 600.0

@onready var player: Player = get_parent()
@onready var stability: StabilityComponent = player.get_node("Stability")
@onready var body_visual: Node2D = player.get_node("BodyVisual")

var stamina: float
var state: String = "idle" # idle | attacking | dodging | parrying
var is_invulnerable: bool = false
var lock_on_target: Node = null

var _state_timer: float = 0.0
var _attack_was_down := false
var _dodge_was_down := false
var _parry_was_down := false
var _lock_was_down := false


func _ready() -> void:
	stamina = max_stamina


func _process(delta: float) -> void:
	stamina = min(max_stamina, stamina + stamina_regen * delta)
	if state != "idle":
		_state_timer -= delta
		if _state_timer <= 0.0:
			state = "idle"
	_handle_input(delta)
	if lock_on_target and is_instance_valid(lock_on_target):
		_face_lock_on_target(delta)
	elif lock_on_target:
		lock_on_target = null
		lock_on_changed.emit(null)


func _handle_input(_delta: float) -> void:
	var mode := GameManager.current_mode
	if mode == GameManager.Mode.DIALOGUE or mode == GameManager.Mode.MENU or mode == GameManager.Mode.CUTSCENE:
		return

	var attack_down := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if attack_down and not _attack_was_down and state == "idle":
		_try_attack()
	_attack_was_down = attack_down

	var dodge_down := Input.is_physical_key_pressed(KEY_SPACE)
	if dodge_down and not _dodge_was_down and state == "idle":
		_try_dodge()
	_dodge_was_down = dodge_down

	var parry_down := Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if parry_down and not _parry_was_down and state == "idle":
		_try_parry()
	_parry_was_down = parry_down

	var lock_down := Input.is_physical_key_pressed(KEY_TAB)
	if lock_down and not _lock_was_down:
		_toggle_lock_on()
	_lock_was_down = lock_down


func _try_attack() -> void:
	if equipped_weapon == null or stamina < equipped_weapon.stamina_cost:
		return
	stamina -= equipped_weapon.stamina_cost
	state = "attacking"
	_state_timer = 1.0 / max(0.1, equipped_weapon.attack_speed)
	GameManager.set_mode(GameManager.Mode.COMBAT)
	attacked.emit(equipped_weapon)
	_resolve_attack_hits()


func _resolve_attack_hits() -> void:
	var facing := Vector2.RIGHT.rotated(body_visual.rotation)
	var weapon := equipped_weapon
	var keywords: Node = player.get_node("Keywords")
	for target in get_tree().get_nodes_in_group("damageable"):
		if target == player or not is_instance_valid(target):
			continue
		var to_target: Vector2 = target.global_position - player.global_position
		if to_target.length() > weapon.range:
			continue
		if to_target.normalized().dot(facing) < attack_cone_dot:
			continue
		var mult := 1.0
		if keywords and target.has_method("get_weakness_tags"):
			mult = keywords.damage_multiplier_against(target.get_weakness_tags())
		target.receive_hit(weapon.damage * mult, weapon.poise_damage, player, weapon)
		AudioManager.play_sfx("hit")


func _try_dodge() -> void:
	state = "dodging"
	_state_timer = dodge_duration
	is_invulnerable = true
	dodged.emit()
	AudioManager.play_sfx("dodge")
	var dir: Vector2 = player.velocity
	if dir.length() < 0.1:
		dir = -Vector2.RIGHT.rotated(body_visual.rotation)
	dir = dir.normalized()
	player.velocity = dir * dodge_speed
	get_tree().create_timer(dodge_iframe_time).timeout.connect(func(): is_invulnerable = false)

	if lock_on_target and lock_on_target.has_method("get_trauma_id"):
		var lateral := ""
		if Input.is_physical_key_pressed(KEY_A):
			lateral = "left"
		elif Input.is_physical_key_pressed(KEY_D):
			lateral = "right"
		if lateral != "":
			SynapseLink.record_dodge(lock_on_target.get_trauma_id(), lateral)


func _try_parry() -> void:
	state = "parrying"
	_state_timer = parry_window
	parry_attempted.emit()


func _toggle_lock_on() -> void:
	if lock_on_target:
		lock_on_target = null
		lock_on_changed.emit(null)
		return
	var best: Node = null
	var best_dist := INF
	for target in get_tree().get_nodes_in_group("trauma"):
		if not is_instance_valid(target):
			continue
		var d: float = player.global_position.distance_to(target.global_position)
		if d <= lock_on_range and d < best_dist:
			best_dist = d
			best = target
	lock_on_target = best
	lock_on_changed.emit(best)


func _face_lock_on_target(delta: float) -> void:
	var to_target: Vector2 = lock_on_target.global_position - player.global_position
	if to_target.length() < 0.01:
		return
	body_visual.rotation = lerp_angle(body_visual.rotation, to_target.angle(), 8.0 * delta)


## Common damageable interface, called by whatever hits the player.
func receive_hit(amount: float, poise_damage: float, attacker: Node, weapon: WeaponData = null) -> void:
	if is_invulnerable:
		return
	if state == "parrying" and weapon != null and weapon.can_be_parried:
		parry_succeeded.emit()
		AudioManager.play_sfx("parry")
		if attacker and attacker.has_method("receive_hit"):
			attacker.receive_hit(0.0, poise_damage * 2.0, player)
		return
	player.take_damage(amount, attacker)
	stability.damage(poise_damage)
