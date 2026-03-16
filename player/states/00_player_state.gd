@icon("res://player/states/state.svg")
class_name PlayerState extends Node

var player : Player
var next_state : PlayerState

#region /// state references
@onready var run: PlayerStateRun = %Run
@onready var idle: PlayerStateIdle = %Idle
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var crouch: PlayerStateCrouch = %Crouch
@onready var sit: PlayerStateSit = %Sit
@onready var climb: PlayerStateClimb = %Climb

#endregion

#what happens when this state is initialized
func init() -> void:
	pass

#what happens when we enter this state?
func _enter() -> void:
	pass

#what happens when we exit this state?
func _exit() -> void:
	pass

#what happens when an imput is pressed?
func handle_input( _event : InputEvent) -> PlayerState:
	return next_state

#what happens each process frame in this state?
func process(_delta: float) -> PlayerState:
	return next_state

#what happens each process frame in this state?
func physics_process(_delta: float) -> PlayerState:
		return next_state
