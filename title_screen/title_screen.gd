extends CanvasLayer
#region /// onready 

@onready var main_menu: VBoxContainer = %MainMenu
@onready var new_game_menu: VBoxContainer = %NewGameMenu
@onready var load_game_menu: VBoxContainer = %LoadGameMenu

@onready var continue_button: Button = %ContinueButton
@onready var new_game_button: Button = %NewGameButton
@onready var load_game_button: Button = %LoadGameButton

@onready var new_slot_01: Button = %NewSlot01
@onready var new_slot_02: Button = %NewSlot02
@onready var new_slot_03: Button = %NewSlot03

@onready var load_slot_01: Button = %LoadSlot01
@onready var load_slot_02: Button = %LoadSlot02
@onready var load_slot_03: Button = %LoadSlot03

@onready var animation_player: AnimationPlayer = $Control/MainMenu/Logo/AnimationPlayer
#endregion

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	new_game_button.pressed.connect(show_new_game_menu)
	load_game_button.pressed.connect(show_load_game_menu)
	
	new_slot_01.pressed.connect(_on_new_game_pressed.bind(0))
	new_slot_02.pressed.connect(_on_new_game_pressed.bind(1))
	new_slot_03.pressed.connect(_on_new_game_pressed.bind(2))
	#connect to button signal 
	load_slot_01.pressed.connect(_on_load_game_pressed.bind(0))
	load_slot_02.pressed.connect(_on_load_game_pressed.bind(1))
	load_slot_03.pressed.connect(_on_load_game_pressed.bind(2))
	
	show_main_menu()
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if main_menu.visible == false:
			show_main_menu()
	pass
	
func show_main_menu() -> void:
	main_menu.visible = true
	new_game_menu.visible = false
	load_game_menu.visible = false
	var most_recent := get_most_recent_slot()
	continue_button.visible = most_recent != -1
	if continue_button.visible:
		continue_button.grab_focus()
	else:
		new_game_button.grab_focus()
	pass
	
func show_new_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = true
	load_game_menu.visible = false
	new_slot_01.grab_focus()
	if SaveManager.save_file_exists(0):
		new_slot_01.text = "Replace Save 01"
	if SaveManager.save_file_exists(1):
		new_slot_02.text = "Replace Save 02"
	if SaveManager.save_file_exists(2):
		new_slot_03.text = "Replace Save 03"
	pass
	
func show_load_game_menu() -> void:
	main_menu.visible = false
	new_game_menu.visible = false
	load_game_menu.visible = true
	load_slot_01.grab_focus()
	load_slot_01.disabled = not SaveManager.save_file_exists(0)
	load_slot_02.disabled = not SaveManager.save_file_exists(1)
	load_slot_03.disabled = not SaveManager.save_file_exists(2)
	pass

func get_most_recent_slot() -> int:
	var most_recent_slot := -1
	var most_recent_time := 0
	for i in range(3):
		if SaveManager.save_file_exists(i):
			var t := FileAccess.get_modified_time(SaveManager.get_file_name(i))
			if t > most_recent_time:
				most_recent_time = t
				most_recent_slot = i
	return most_recent_slot


func _on_continue_pressed() -> void:
	SaveManager.load_game(get_most_recent_slot())
	pass



func _on_new_game_pressed(slot : int) -> void:
	SaveManager.create_new_game_save(slot)
	SceneManager.transition_scene("uid://bpmbexp2p7wki","", Vector2.ZERO, "up") #mettre la scène de début de jeu ici
	pass


func _on_load_game_pressed(slot : int) -> void:
	SaveManager.load_game(slot)
	pass
