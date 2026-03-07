class_name PauseMenu extends CanvasLayer
#region /// onready 
@onready var pause_screen: Control = %PauseScreen
@onready var system: Control = %System

@onready var system_menu_bouton: Button = %SystemMenuBouton

@onready var back_map_button: Button = %BackMapButton
@onready var back_title_button: Button = %BackTitleButton
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var ui_slider: HSlider = %UISlider
#endregion

var player: Player

func _ready() -> void:
	#grab player
	show_pause_screen()
	system_menu_bouton.pressed.connect(show_system_menu)
	#audio setup
	setup_system_menu()
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	pass

func show_pause_screen()  -> void:
	pause_screen.visible = true
	system.visible = false
	system_menu_bouton.grab_focus()
	pass

func show_system_menu()  -> void:
	pause_screen.visible = false
	system.visible = true
	back_map_button.grab_focus()
	pass

func setup_system_menu()-> void:
	back_title_button.pressed.connect(_on_back_to_title_pressed)
	back_map_button.pressed.connect(show_pause_screen)
	pass
	
func _on_back_to_title_pressed()-> void:
	get_tree().paused = false
	queue_free()
	SceneManager.transition_scene("res://title_screen/title_screen.tscn","", Vector2.ZERO, "up" )
	pass
