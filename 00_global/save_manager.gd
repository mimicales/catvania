#SaveManager Script
extends Node

const SLOTS : Array[String] = ["save_01","save_02","save_03" ]


var current_slot : int = 0
var save_data : Dictionary
var discovered_areas : Array = []
var persistent_data : Dictionary = {}


func _ready() -> void:
	SceneManager.scene_entered.connect(_on_scene_entered)
	pass

func create_new_game_save(slot :int) -> void:
	current_slot = slot
	discovered_areas.clear()
	persistent_data.clear()
	#liste de tout ce qu'on doit savoir pour enregistrer, les habiletés, etc...
	var new_game_scene : String = "uid://bpmbexp2p7wki" #scene du début du jeu à changer éventuellement
	discovered_areas.append(new_game_scene)
	save_data = {
		"scene_path" : new_game_scene,
		"x" : 51,
		"y" : 167,
		"hp" : 20, 
		"max_hp" : 20,
		"energy" : 20, 
		"max_energy" : 20,
		"double_jump" : false, 
		"swim" : false, 
		"night_vision" : false, 
		"ground_slam" : false,
		"morph_roll" : false, 
		"discovered_areas" : discovered_areas, 
		"persistent_data" : persistent_data,
	}
	#Save Game Data
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	save_file.close()
	load_game(slot)
	pass


func save_game() -> void:
	var player : Player = get_tree().get_first_node_in_group("Player")
	save_data = {
		"scene_path" : SceneManager.current_scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.hp, 
		"max_hp" : player.max_hp,
		"energy" : player.energy, 
		"max_energy" : player.max_energy,
		"double_jump" : player.double_jump, 
		"swim" : player.swim, 
		"night_vision" : player.night_vision, 
		"ground_slam" : player.ground_slam,
		"morph_roll" : player.morph_roll, 
		"discovered_areas" : discovered_areas, 
		"persistent_data" : persistent_data,
	}
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	pass

func load_game(slot :int) -> void:
	current_slot = slot
	if not FileAccess.file_exists(get_file_name(current_slot)):
		return
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line())
	
	persistent_data = save_data.get("persistent_data",{} )
	discovered_areas = save_data.get("discovered_areas",[] )
	var scene_path : String = save_data.get("scene_path","uid://bpmbexp2p7wki" )
	SceneManager.transition_scene(scene_path,"", Vector2.ZERO, "up" )
	await SceneManager.new_scene_ready
	setup_player()
	pass


func setup_player() -> void:
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	player.max_hp = save_data.get("max_hp",20 )
	player.hp = save_data.get("hp",20 )
	player.max_energy = save_data.get("max_energy",20 )
	player.energy = save_data.get("energy",20 )
	player.double_jump = save_data.get("double_jump",false )
	player.swim = save_data.get("swim",false )
	player.night_vision = save_data.get("night_vision",false )
	player.ground_slam = save_data.get("ground_slam",false )
	player.morph_roll = save_data.get("morph_roll",false )
	player.global_position = Vector2(save_data.get("x",0 ),save_data.get("y",0 ))
	pass


func get_file_name(slot: int)-> String:
	return "user://" + SLOTS [slot] + ".sav"


func save_file_exists(slot:int) -> bool:
	return FileAccess.file_exists(get_file_name(slot))


func is_area_discovered(scene_uid:String) -> bool:
	return discovered_areas.has(scene_uid)

func _on_scene_entered(scene_uid :String) -> void:
	if discovered_areas.has(scene_uid):
		return
	else:
		discovered_areas.append(scene_uid)
	pass
