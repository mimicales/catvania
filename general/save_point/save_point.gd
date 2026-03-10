@icon ("res://general/icons/save_point.svg")
class_name SavePoint extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer

var heal_timer: Timer
var _player_ref: Player = null


func _ready() -> void:
	area_2d.body_entered.connect(_on_player_entered)
	area_2d.body_exited.connect(_on_player_exited)
	heal_timer = Timer.new()
	heal_timer.wait_time = 1.0
	heal_timer.timeout.connect(_on_heal_tick)
	add_child(heal_timer)

func _on_player_entered(_n: Node2D) -> void:
	Messages.player_interacted.connect(_on_player_interacted)
	Messages.input_hint_changed.emit("action")

func _on_player_exited(_n: Node2D) -> void:
	Messages.player_interacted.disconnect(_on_player_interacted)
	Messages.input_hint_changed.emit("")
	_stop_healing()
	SaveManager.save_game()

func _on_player_interacted(player: Player) -> void:
	Messages.input_hint_changed.emit("")
	player.change_state(player.current_state.sit)
	animation_player.play("game_saved")
	animation_player.seek(0)
	_player_ref = player
	if _player_ref.hp < _player_ref.max_hp:
		Messages.player_healed.emit(2)
	if _player_ref.energy < _player_ref.max_energy:
		Messages.player_energize.emit(1)
	heal_timer.start()
	SaveManager.save_game()

func _on_heal_tick() -> void:
	if _player_ref == null or not (_player_ref.current_state is PlayerStateSit):
		_stop_healing()
		return
	var hp_full := _player_ref.hp >= _player_ref.max_hp
	var energy_full := _player_ref.energy >= _player_ref.max_energy
	if hp_full and energy_full:
		_stop_healing()
		return
	if not hp_full:
		Messages.player_healed.emit(2)
	if not energy_full:
		Messages.player_energize.emit(1)

func _stop_healing() -> void:
	heal_timer.stop()
	_player_ref = null
