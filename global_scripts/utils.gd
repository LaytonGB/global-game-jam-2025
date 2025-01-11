extends Node


func is_facing_left(node: Node2D) -> bool:
    assert(node)

    return node.scale.y == -1 and abs(node.rotation_degrees) == 180
