extends CanvasLayer

signal load_scene_started
signal new_scene_ready(target_name : String, offset : Vector2)
signal load_scene_finished
signal scene_entered(uid:String)

var current_scene_uid : String
var is_transitioning : bool = false

func _ready() -> void:
	await get_tree().process_frame
	load_scene_finished.emit()
	var current_scene : String = get_tree().current_scene.scene_file_path
	current_scene_uid = ResourceUID.path_to_uid(current_scene)
	scene_entered.emit(current_scene_uid)
	pass

func transition_scene(new_scene : String, target_area : String, player_offset : Vector2, _dir : String) -> void:
	is_transitioning = true
	load_scene_started.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(new_scene)
	current_scene_uid = ResourceUID.path_to_uid(new_scene)
	scene_entered.emit(current_scene_uid)
	await get_tree().scene_changed
	new_scene_ready.emit(target_area, player_offset)
	await get_tree().process_frame
	load_scene_finished.emit()
	is_transitioning = false
	pass
