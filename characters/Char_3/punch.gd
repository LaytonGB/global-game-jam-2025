extends Node2D


@export var PUNCH_POWER: float = 150


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.has_method("be_attacked") and not body.is_ancestor_of(self):
        body.call("be_attacked", self.global_position, PUNCH_POWER)
