class_name PlayerStateFall extends PlayerState

@export var coyote_time : float = 0.125
@export var fall_gravity_multiplier : float = 1.165
@export var jump_buffer_time : float = 0.2

var coyote_timer : float = 0
var buffer_timer : float = 0

#what happens when this state is initialized
func init() -> void:
	#ajouter animation
	pass

#what happens when we enter this state?
func _enter() -> void:
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multiplier
	if player.previous_state == jump:
		coyote_timer = 0
	else :
		coyote_timer = coyote_time
	pass

#what happens when we exit this state?
func _exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	pass

#what happens when an imput is pressed?
func handle_input(_event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		if coyote_timer > 0:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state

#what happens each process frame in this state?
func process(delta: float) -> PlayerState:
	coyote_timer -= delta
	buffer_timer -= delta
	set_jump_frame()
	return next_state

#what happens each process frame in this state?
func physics_process(_delta: float) -> PlayerState:
	if climb.is_on_climbable() and player.direction.y < -0.5:
		return climb
	if player.is_on_floor():
		if buffer_timer > 0:
			return jump
		return idle
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0)
	player.animation_player.seek(frame, true)
	pass
