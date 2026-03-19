class_name CastShadow extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var point_light_2d: PointLight2D = $PointLight2D


var ray_y_collision_point: float = 0.0

func _physics_process(_delta: float) -> void:
	if ray_cast_2d.is_colliding():
		ray_y_collision_point = ray_cast_2d.get_collision_point().y
	else:
		ray_y_collision_point = ray_cast_2d.global_position.y + ray_cast_2d.target_position.y
	point_light_2d.global_position.y = ray_y_collision_point
	point_light_2d.energy = max( 0.5 - point_light_2d.position.y/128, 0)
	pass
