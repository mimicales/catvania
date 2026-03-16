class_name PlayerStateRun extends PlayerState

#what happens when this state is initialized
func init() -> void:
	pass

#what happens when we enter this state?
func _enter() -> void:
	player.animation_player.play("run")
	pass

#what happens when we exit this state?
func _exit() -> void:
	pass

#what happens when an imput is pressed?
func handle_input(_event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	return next_state

#what happens each process frame in this state?
func process(_delta: float) -> PlayerState:
	if player.direction.y < -0.5 and climb.is_on_climbable():
		return climb
	if player.direction.x == 0:
		return idle
	elif player.direction.y > 0.5:
		return crouch
	return next_state

#what happens each process frame in this state?
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false:
		return fall
	return next_state

func get_surface_type() -> String:
	var containers = player.get_tree().get_nodes_in_group("tilemap")
	for container in containers:
		for child in container.get_children():
			var tilemap = child as TileMapLayer
			if not tilemap:
				continue
			var local_pos = tilemap.to_local(player.global_position + Vector2(0, 4))
			var cell = tilemap.local_to_map(local_pos)
			var data = tilemap.get_cell_tile_data(cell)  # pas de paramètre layer
			if data:
				var surface = data.get_custom_data("surface_type")
				if surface != "":
					return surface
	return "default"

func play_footstep() -> void:
	var surface = get_surface_type()
	Audio.play_run_step(surface)
