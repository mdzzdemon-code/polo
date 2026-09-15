extends Node
## Central key polling for menu toggles, so individual panels don't each
## duplicate input handling. I = Inventaire, C = Carnet de l'Anomalie,
## V = Carnet de Réalité, Escape = close whatever is open.

var _i_was_down := false
var _c_was_down := false
var _v_was_down := false
var _esc_was_down := false


func _process(_delta: float) -> void:
	var mode := GameManager.current_mode
	if mode == GameManager.Mode.DIALOGUE or mode == GameManager.Mode.CUTSCENE:
		return

	_poll(KEY_I, "_i_was_down", &"inventory")
	_poll(KEY_C, "_c_was_down", &"carnet_anomalie")
	_poll(KEY_V, "_v_was_down", &"carnet_realite")

	var esc_down := Input.is_physical_key_pressed(KEY_ESCAPE)
	if esc_down and not _esc_was_down and UIManager.is_open():
		UIManager.close()
	_esc_was_down = esc_down


func _poll(key: Key, state_field: String, panel_name: StringName) -> void:
	var down := Input.is_physical_key_pressed(key)
	if down and not get(state_field):
		UIManager.toggle(panel_name)
	set(state_field, down)
