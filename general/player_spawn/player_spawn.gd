@icon("res://general/icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D


func _ready() -> void:
	add_to_group("PlayerSpawn")
	visible = false
	await get_tree().process_frame
	#check to see if we have a player
	if get_tree().get_first_node_in_group("Player"):
		return
	var player : Player = load("res://player/player.tscn").instantiate()
	get_tree().root.add_child(player)
	player.global_position = self.global_position
	pass
