class_name JumpPlayerState extends PlayerState


@export var jump_power: float = 12.5
@export var jump_recoil_amount: Vector3 = Vector3(10.0, 0.0, 2.0)
@export_group("SFX")
@export var jump_sound: AudioStreamPlayer = null
@export var land_sound: AudioStreamPlayer = null

func enter(previous_state: PlayerState) -> void:
	spd = previous_state.spd
	acc = previous_state.acc
	player.velocity.y += jump_power
	
	player.camera.add_recoil(jump_recoil_amount)
	jump_sound.pitch_scale = randf_range(0.85, 1.15)
	jump_sound.play()

func update(delta: float) -> void:
	player.update_movement(spd, acc, delta)
	player.update_gravity(delta)
	player.update_velocity()
	if player.is_on_floor(): transition.emit("IdlePlayerState")

func exit() -> void:
	player.camera.add_recoil(-jump_recoil_amount)
	land_sound.pitch_scale = randf_range(0.85, 1.15)
	land_sound.play()
