extends Node


@warning_ignore_start("unused_signal")
signal player_interacted(player : Player)
signal player_healed(amount : float)
signal player_energize(amount : float)
signal input_hint_changed(hint : String)
signal player_health_changed (hp:float, max_hp:float)
signal player_energy_changed (energy:float, max_energy:float)
@warning_ignore_restore("unused_signal")
