#PlayerHud
extends CanvasLayer

@onready var hp_margin_container: MarginContainer = %HPMarginContainer
@onready var hp_bar: TextureProgressBar = %HPBar
@onready var energy_margin_container: MarginContainer = %EnergyMarginContainer
@onready var energy_bar: TextureProgressBar = %EnergyBar


func _ready() -> void:
	Messages.player_health_changed.connect(update_health_bar)
	Messages.player_energy_changed.connect(update_energy_bar)
	pass
	
	
#faire quelque chose du style pour coins (update_coins) ou mana
func update_health_bar(hp: float, max_hp:float) -> void:
	var value:float = (hp/max_hp)*100
	hp_bar.value = value
	hp_margin_container.size.x = max_hp +22
	pass

func update_energy_bar(energy: float, max_energy:float) -> void:
	var value:float = (energy/max_energy)*100
	energy_bar.value = value
	energy_margin_container.size.x = max_energy +26
	pass
