extends Node3D


@export var MAX_ROTATION_DELTA: float = 0.3
@export var MAX_ROTATION: float = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    rotation_degrees.x += get_rand_rotation()
    rotation_degrees.z += get_rand_rotation()


func get_rand_rotation() -> float:
    return clampf(randf_range(-MAX_ROTATION_DELTA, MAX_ROTATION_DELTA), -MAX_ROTATION, MAX_ROTATION)
