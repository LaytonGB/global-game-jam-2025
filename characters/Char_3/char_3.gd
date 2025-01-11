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
    if Input.is_action_just_pressed(ACTION["jump"]) and is_on_floor() and not is_stunned():
        velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_axis(ACTION["left"], ACTION["right"])
    if direction and not is_stunned():
        if is_on_floor():
            velocity.x = direction * SPEED
        else:
            velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / AIR_MOVEMENT_FRACTION)
    elif is_on_floor():
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    update_sprite(direction)

    if Input.is_action_just_pressed(ACTION["attack"]) and not %AnimationPlayer.current_animation:
        if is_on_floor():
            start_animation("punch")
        else:
            start_animation("kick")


func be_punched(puncher_position: Vector2, punch_power: float) -> void:
    start_animation("hurt")

    if puncher_position.x < global_position.x:
        velocity = Vector2(punch_power, -punch_power * 1.2)
    else:
        velocity = Vector2(-punch_power, -punch_power * 1.2)


func update_sprite(direction: float) -> void:
    if direction < 0:
        if not $/root/Utils.is_facing_left(self):
            scale.x = -1
    elif direction > 0:
        if $/root/Utils.is_facing_left(self):
            scale.x = -1

    if is_on_floor() and not %AnimationPlayer.current_animation and not %Stand.visible:
        %AnimationPlayer.play("RESET")
    elif not is_on_floor() and not %AnimationPlayer.current_animation and not (%Jump.visible or %Kick.visible):
        start_animation("jump")


func start_animation(action_name: String) -> void:
    assert(action_name in ["punch", "hurt", "jump", "kick", "move", "parry"], "invalid action used")

    match action_name:
        "punch":
            %AnimationPlayer.play("punch")
        "hurt":
            %AnimationPlayer.play("hurt")
        "jump":
            %AnimationPlayer.play("jump")
            return
        "kick":
            %AnimationPlayer.play("kick")
            return
        "move":
            return
        "parry":
            %AnimationPlayer.play("parry")

    %AnimationPlayer.queue("RESET")


func is_stunned() -> bool:
    return %AnimationPlayer.current_animation == "hurt"
