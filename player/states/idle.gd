class_name PlayerStateIdle extends PlayerState




#what happens when this state is initialized
func init() -> void:
	#ici je pourrais mettre l'animation idle du joueur
	pass

#what happens when we enter this state?
func _enter() -> void:
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
	if player.direction.x != 0:
		return run
	elif player.direction.y > 0.5:
		return crouch
	return next_state

#what happens each process frame in this state?
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state
