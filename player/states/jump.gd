class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450

#what happens when this state is initialized
func init() -> void:
	pass

#what happens when we enter this state?
func _enter() -> void:
	#play animation
	player.velocity.y = -jump_velocity
	pass

#what happens when we exit this state?
func _exit() -> void:
	pass

#what happens when an imput is pressed?
func handle_input(_event : InputEvent) -> PlayerState:
	if _event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return next_state

#what happens each process frame in this state?
func process(_delta: float) -> PlayerState:
	return next_state

#what happens each process frame in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state
