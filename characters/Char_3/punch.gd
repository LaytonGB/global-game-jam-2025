extends Node2D


@export var PUNCH_POWER: float


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.has_method("be_punched") and not body.is_ancestor_of(self):
        body.call("be_punched", self.position, PUNCH_POWER)
