class_name PlayerStateClimb extends PlayerState

@export var climb_speed: float = 80.0
var snap_x: float = 0.0   # <-- stocker le centre du tile

func init() -> void:
	pass

func _enter() -> void:
	player.gravity_multiplier = 0.0
	player.velocity = Vector2.ZERO
	snap_x = get_climbable_tile_center_x()   # <-- snap dès l'entrée
	player.global_position.x = snap_x
	player.animation_player.play("climb")
	player.animation_player.seek(0, true)
	player.animation_player.pause()

func _exit() -> void:
	player.gravity_multiplier = 1.0

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		player.velocity.y = 0.0
		return jump
	return next_state

func process(_delta: float) -> PlayerState:
	if not is_on_climbable():
		return fall
	if player.direction.y == 0:
		player.animation_player.seek(0, true)
		player.animation_player.pause()
	else:
		player.animation_player.play("climb")
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	player.global_position.x = snap_x       # <-- verrouiller chaque frame
	player.velocity.y = player.direction.y * climb_speed
	if player.is_on_floor() and player.direction.y >= 0:
		return idle
	return next_state

# Retourne le centre X mondial du tile climbable sous le joueur
func get_climbable_tile_center_x() -> float:
	var containers = player.get_tree().get_nodes_in_group("tilemap")
	for container in containers:
		for child in container.get_children():
			var tilemap = child as TileMapLayer
			if not tilemap:
				continue
			var local_pos = tilemap.to_local(player.global_position)
			var cell = tilemap.local_to_map(local_pos)
			var data = tilemap.get_cell_tile_data(cell)
			if data and data.get_custom_data("surface_type") == "climb":
				var tile_center_local = tilemap.map_to_local(cell)
				return tilemap.to_global(tile_center_local).x
	return player.global_position.x  # fallback: position actuelle

func is_on_climbable() -> bool:
	var containers = player.get_tree().get_nodes_in_group("tilemap")
	for container in containers:
		for child in container.get_children():
			var tilemap = child as TileMapLayer
			if not tilemap:
				continue
			var local_pos = tilemap.to_local(player.global_position)
			var cell = tilemap.local_to_map(local_pos)
			var data = tilemap.get_cell_tile_data(cell)
			if data and data.get_custom_data("surface_type") == "climb":
				return true
	return false
