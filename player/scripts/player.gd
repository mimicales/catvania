class_name Player extends CharacterBody2D


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_stand: CollisionShape2D = $CollisionStand
@onready var collision_crouch: CollisionShape2D = $CollisionCrouch
@onready var one_way_platform_shape_cast: ShapeCast2D = $OneWayPlatformRayCast
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var max_fall_velocity : float = 600
@export var move_speed : float = 150

#region /// State Machine Variables
var states : Array [PlayerState]
var current_state : PlayerState :
	get : return states.front()
var previous_state : PlayerState :
	get : return states[1]
#endregion

#region /// Player Stats
var hp : float = 20 :
	set(value):
		hp = clampf(value, 0, max_hp)
		Messages.player_health_changed.emit(hp, max_hp)
var max_hp : float = 20:
	set(value):
		max_hp = value
		Messages.player_health_changed.emit(hp, max_hp)
var double_jump : bool = false
var swim : bool = false 
var night_vision : bool = false 
var ground_slam : bool = false 
var morph_roll : bool = false 
#endregion

#region /// Standard Variables
var direction : Vector2 = Vector2.ZERO
var gravity : float = 980
var gravity_multiplier : float = 1.0

#endregion


func _ready() -> void:
	if get_tree().get_first_node_in_group("Player") != self:
		self.queue_free()
	initialize_states()
	self.call_deferred("reparent",get_tree().root)
	Messages.player_healed.connect(_on_player_healed)
	pass

#use pour connecter avec le input du joueur
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		Messages.player_interacted.emit(self)
	elif event.is_action_pressed("pause"):
		get_tree().paused = true
		var pause_menu : PauseMenu = load("res://pause_menu/pause_menu.tscn").instantiate()
		add_child(pause_menu)
		return
	#A ENLEVER EVENTUELLEMENT
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_MINUS:
			if Input.is_key_pressed(KEY_SHIFT):
				max_hp -=10
			else:
				hp -=5
		elif event.keycode == KEY_EQUAL:
			if Input.is_key_pressed(KEY_SHIFT):
				max_hp +=10
			else:
				hp +=5
		
	change_state(current_state.handle_input(event))
	pass


#use for frame rate c'est a dire si ton jeu va a 60fps tu vas faire ceci 60xparseconde
func _process(_delta: float) -> void:
	update_direction()
	change_state( current_state.process(_delta))
	pass


#use for physics calculation delta=how much time has passed since the last frame
func _physics_process(_delta: float) -> void:
	velocity.y += gravity * _delta * gravity_multiplier
	velocity.y = clampf(velocity.y, -1000, max_fall_velocity)
	move_and_slide()
	change_state( current_state.physics_process(_delta))
	pass

#Pour initialiser le state
func initialize_states() -> void:
	states = []
	#gather all the states
	for c in $States.get_children():
		if c is PlayerState:
			states.append( c )
			c.player = self
		pass
	if states.size() == 0:
		return

	#initialize all states
	for state in states:
		state.init()
	
	#set our first states
	change_state(current_state)
	current_state._enter()
	$Label.text = current_state.name
	pass
	
#Pour changer le state
func change_state( new_state : PlayerState) -> void:
	if new_state == null:
		return
	elif new_state == current_state:
		return
	if current_state:
		current_state._exit()
	states.push_front( new_state)
	current_state._enter()
	states.resize(3)
	$Label.text = current_state.name
	pass


func update_direction() -> void:
	var prev_direction : Vector2 = direction
	
	var x_axis = Input.get_axis( "left", "right")
	var y_axis = Input.get_axis( "up", "down")
	direction = Vector2(x_axis, y_axis)
	
	if prev_direction.x != direction.x:
		if direction.x <0:
			sprite.flip_h = true
		elif direction.x >0:
			sprite.flip_h = false
	pass


func _on_player_healed(amount : float)-> void:
	hp = min(hp + amount, max_hp)
	pass
