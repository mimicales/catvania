@tool
@icon ("res://general/icons/level_bounds.svg")
class_name LevelBounds extends Node2D

@export_range (480, 2048, 32, "suffix:px") var width : int = 480 : set = _on_width_changed
@export_range (270, 2048, 32, "suffix:px") var height : int = 270 : set = _on_height_changed


func _ready() -> void:
	z_index = 256
	if Engine.is_editor_hint():
		return
	apply_camera_limits()	
	
func apply_camera_limits() -> void:
	var camera : Camera2D = get_viewport().get_camera_2d()
	while not camera:
		await get_tree().process_frame
		apply_camera_limits()
		return
	camera = get_viewport().get_camera_2d()
	camera.limit_left = int(global_position.x)
	camera.limit_top = int(global_position.y)
	camera.limit_right = int(global_position.x) + width
	camera.limit_bottom = int(global_position.y) + height
	pass

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if SceneManager.is_transitioning:
		return
	var player : Node2D = get_tree().get_first_node_in_group("Player")
	if not player:
		return
	var bounds := Rect2(global_position, Vector2(width, height))
	if not bounds.has_point(player.global_position):
		_respawn_player(player)

func _respawn_player(player: Node2D) -> void:
	var spawn : Node2D = get_tree().get_first_node_in_group("PlayerSpawn")
	if spawn:
		player.global_position = spawn.global_position
	player.hp -= 2

func _draw() -> void:
	if Engine.is_editor_hint():
		var r : Rect2 = Rect2(Vector2.ZERO, Vector2(width, height))
		draw_rect(r, Color(0.0, 0.45, 1.0, 0.6), false, 3)
		draw_rect(r, Color(0.0, 0.75, 1.0), false, 1)
	pass

func _on_width_changed( new_width :int) -> void:
	width = new_width
	queue_redraw()
	pass

func _on_height_changed( new_height :int) -> void:
	height = new_height
	queue_redraw()
	pass
