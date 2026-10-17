class_name FallPlayerState extends PlayerState

@export var jump_recoil_amount: Vector3 = Vector3(5.0, 0.0, 3.0)

func enter(previous_state: PlayerState) -> void:
	spd = previous_state.spd
	acc = previous_state.acc

func update(delta: float) -> void:
	player.update_movement(spd, acc, delta)
	player.update_gravity(delta)
	player.update_velocity()
	if player.is_on_floor(): transition.emit("IdlePlayerState")

func exit() -> void:
	#land_sound.play()
	player.camera.add_recoil(-jump_recoil_amount)
