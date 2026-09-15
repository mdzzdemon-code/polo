extends Control

@onready var health_bar: ProgressBar = $Margin/HealthBar
@onready var stability_bar: ProgressBar = $Margin/StabilityBar
@onready var interact_label: Label = $InteractLabel
@onready var time_label: Label = $TimeLabel
@onready var lock_on_reticle: Control = $LockOnReticle


func _ready() -> void:
	interact_label.hide()
	lock_on_reticle.hide()
	if GameManager.player:
		_bind_player(GameManager.player)
	else:
		GameManager.player_registered.connect(_bind_player)
	TimeManager.hour_changed.connect(_on_time_changed)
	TimeManager.day_changed.connect(_on_time_changed)
	_on_time_changed(0)


func _bind_player(player: Player) -> void:
	player.health_changed.connect(_on_health_changed)
	player.stability.changed.connect(_on_stability_changed)
	player.interaction_component.focus_changed.connect(_on_focus_changed)
	player.combat.lock_on_changed.connect(_on_lock_on_changed)
	_on_health_changed(player.health, player.max_health)
	_on_stability_changed(player.stability.current_stability, player.stability.max_stability)


func _on_health_changed(current: float, max_health: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = current


func _on_stability_changed(current: float, max_stability: float) -> void:
	stability_bar.max_value = max_stability
	stability_bar.value = current


func _on_focus_changed(interactable: Node) -> void:
	if interactable and "prompt_text" in interactable:
		interact_label.text = "[E] " + interactable.prompt_text
		interact_label.show()
	else:
		interact_label.hide()


func _on_lock_on_changed(target: Node) -> void:
	lock_on_reticle.visible = target != null


func _on_time_changed(_arg = 0) -> void:
	time_label.text = "Jour %d — %02dh%02d" % [TimeManager.day, TimeManager.hour(), int(TimeManager.minute_of_day) % 60]
