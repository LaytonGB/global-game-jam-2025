extends Area2D


func _on_body_entered(body: Node2D) -> void:
    if body.has_method("be_defeated"):
        body.call("be_defeated")
