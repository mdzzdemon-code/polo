extends Node
## Free 8-directional top-down movement (not grid-locked — the real-time
## dodge/parry/lock-on combat needs smooth positioning). BodyVisual rotates
## to face the movement direction; Camera2D is a plain child of Player so it
## just translates with it — no camera rotation in a top-down view.

@export var walk_speed: float = 160.0
@export var run_speed: float = 300.0
@export var turn_speed: float = 14.0

@onready var player: Player = get_parent()
@onready var body_visual: Node2D = player.get_node("BodyVisual")


func _physics_process(delta: float) -> void:
	var mode := GameManager.current_mode
	if mode == GameManager.Mode.DIALOGUE or mode == GameManager.Mode.MENU or mode == GameManager.Mode.CUTSCENE:
		return

	var input_dir := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W):
		input_dir.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S):
		input_dir.y += 1.0
	if Input.is_physical_key_pressed(KEY_A):
		input_dir.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D):
		input_dir.x += 1.0
	if input_dir.length() > 0.01:
		input_dir = input_dir.normalized()

	var speed := run_speed if Input.is_physical_key_pressed(KEY_SHIFT) else walk_speed
	player.velocity = input_dir * speed
	player.move_and_slide()

	# Combat.gd owns facing while locked onto a Trauma.
	if input_dir.length() > 0.01 and player.combat.lock_on_target == null:
		body_visual.rotation = lerp_angle(body_visual.rotation, input_dir.angle(), turn_speed * delta)
