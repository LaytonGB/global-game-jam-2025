extends Node


func is_facing_left(node: Node2D) -> bool:
    assert(node)

    return roundf(abs(node.scale.y) * 10000) / 10000 and abs(node.rotation_degrees) == 180


func get_keyboard_actions(player_number: int) -> Dictionary:
    assert(player_number >= 1 and player_number <= 2)

    return {
        "left": "p1_move_left" if player_number == 1 else "p2_move_left",
        "right": "p1_move_right" if player_number == 1 else "p2_move_right",
        "jump": "p1_jump" if player_number == 1 else "p2_jump",
        "attack": "p1_attack" if player_number == 1 else "p2_attack",
        "parry": "p1_parry" if player_number == 1 else "p2_parry",
    }
