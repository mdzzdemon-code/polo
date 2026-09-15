extends Node
## Camera-relative movement for the Player (CharacterBody3D parent), plus
## mouse-look for the camera rig itself (yaw on CameraRig, pitch on SpringArm).

@export var walk_speed: float = 4.0
@export var run_speed: float = 7.5
@export var gravity: float = 18.0
@export var turn_speed: float = 12.0
@export var mouse_sensitivity: float = 0.0025
@export var pitch_min_deg: float = -70.0
@export var pitch_max_deg: float = 30.0

@onready var player: Player = get_parent()
@onready var camera_rig: Node3D = player.get_node("CameraRig")
@onready var spring_arm: SpringArm3D = camera_rig.get_node("SpringArm")
@onready var body_mesh: Node3D = player.get_node("BodyMesh")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.mode_changed.connect(_on_mode_changed)


func _on_mode_changed(mode: GameManager.Mode) -> void:
	# Free the cursor for menus/dialogue (clickable buttons), recapture it for
	# camera-look otherwise.
	if mode == GameManager.Mode.DIALOGUE or mode == GameManager.Mode.MENU or mode == GameManager.Mode.CUTSCENE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouseMotion) or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	var motion := event as InputEventMouseMotion
	# While locked on, Combat.gd owns the camera's yaw (it faces the target);
	# mouse-look still controls pitch so the player can look the target up/down.
	if player.combat.lock_on_target == null:
		camera_rig.rotation.y -= motion.relative.x * mouse_sensitivity
	var new_pitch := spring_arm.rotation.x - motion.relative.y * mouse_sensitivity
	spring_arm.rotation.x = clamp(new_pitch, deg_to_rad(pitch_min_deg), deg_to_rad(pitch_max_deg))


func _physics_process(delta: float) -> void:
	var mode := GameManager.current_mode
	if mode == GameManager.Mode.DIALOGUE or mode == GameManager.Mode.MENU or mode == GameManager.Mode.CUTSCENE:
		return

	var input_dir := Vector3.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		input_dir.z -= 1.0
	if Input.is_physical_key_pressed(KEY_S):
		input_dir.z += 1.0
	if Input.is_physical_key_pressed(KEY_A):
		input_dir.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D):
		input_dir.x += 1.0

	var cam_basis := camera_rig.global_transform.basis
	var forward := -cam_basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var right := cam_basis.x
	right.y = 0.0
	right = right.normalized()

	var move_dir := (forward * -input_dir.z + right * input_dir.x)
	if move_dir.length() > 0.01:
		move_dir = move_dir.normalized()

	var speed := run_speed if Input.is_physical_key_pressed(KEY_SHIFT) else walk_speed
	var vel := player.velocity
	vel.x = move_dir.x * speed
	vel.z = move_dir.z * speed

	if player.is_on_floor():
		vel.y = -0.5
	else:
		vel.y -= gravity * delta

	player.velocity = vel
	player.move_and_slide()

	if move_dir.length() > 0.01 and body_mesh:
		var target_yaw := atan2(move_dir.x, move_dir.z)
		body_mesh.rotation.y = lerp_angle(body_mesh.rotation.y, target_yaw, turn_speed * delta)
