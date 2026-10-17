class_name JumpPlayerState extends PlayerState

@export var vault_shape_cast: ShapeCast3D
@export var vault_ray_cast_up: RayCast3D
@export var jump_power: float = 12.5
@export var jump_recoil_amount: Vector3 = Vector3(5.0, 0.0, 3.0)

func enter(previous_state: PlayerState) -> void:
	spd = previous_state.spd
	acc = previous_state.acc
	player.velocity.y += jump_power

func update(delta: float) -> void:
	player.update_movement(spd, acc, delta)
	player.update_gravity(delta)
	player.update_velocity()
	if player.is_on_floor(): transition.emit("IdlePlayerState")
	if Input.is_action_just_pressed("jump") && vault_shape_cast.is_colliding() && !vault_ray_cast_up.is_colliding() && player.new_vault_wall != player.previous_vault_wall: transition.emit("VaultPlayerState")

func exit() -> void:
	#land_sound.play()
	player.camera_pivot.add_recoil(-jump_recoil_amount)
