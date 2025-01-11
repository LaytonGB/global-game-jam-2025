extends CharacterBody2D


@export var SPEED: float
@export var JUMP_VELOCITY: float
@export var AIR_MOVEMENT_FRACTION: float

@export var PLAYER_NUMBER: int


@onready var ACTION: Dictionary = $/root/Utils.get_keyboard_actions(PLAYER_NUMBER)


func _ready() -> void:
    %AnimationPlayer.play("RESET")


func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    if Input.is_action_just_pressed(ACTION["jump"]) and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_axis(ACTION["left"], ACTION["right"])
    if direction:
        if is_on_floor():
            velocity.x = direction * SPEED
        else:
            velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / AIR_MOVEMENT_FRACTION)
    elif is_on_floor():
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    update_sprite()


func update_sprite() -> void:
    if velocity.x < 0:
        if not $/root/Utils.is_facing_left(self):
            scale.x = -1
    elif velocity.x > 0:
        if $/root/Utils.is_facing_left(self):
            scale.x = -1

    if is_on_floor() and not %AnimationPlayer.current_animation and not %Stand.visible:
        %Jump.visible = false
        %Stand.visible = true
    elif not is_on_floor() and not %AnimationPlayer.current_animation and not %Jump.visible:
        %Stand.visible = false
        %Jump.visible = true


func _do_action(action_name: String) -> void:
    assert(action_name in ["punch", "hurt", "jump", "kick", "move", "parry"], "invalid action used")

    match action_name:
        "punch":
            %AnimationPlayer.play("punch")
        "hurt":
            %AnimationPlayer.play("hurt")
        "jump":
            return
        "kick":
            return
        "move":
            return
        "parry":
            %AnimationPlayer.play("parry")

    await %AnimationPlayer.animation_finished
    %AnimationPlayer.play("RESET")


func is_facing_right() -> bool:
    return scale.y == 1
