class_name VaultPlayerState extends PlayerState

@export var vault_shape_cast: ShapeCast3D
@export var vault_ray_cast_down: RayCast3D
#@export var vault_sfx: AudioStreamPlayer
@export var enter_recoil_amount: Vector3 = Vector3(10.0, 1.0, 5.0)
@export var exit_recoil_amount: Vector3 = Vector3(1.0, 1.0, 1.0)
var dir: Vector3 = Vector3.UP

func enter(_previous_state: PlayerState) -> void:
	player.previous_vault_wall = vault_shape_cast.get_collider_rid(0)
	#vault_sfx.play()
	player.camera_pivot.add_recoil(enter_recoil_amount)

func update(delta: float) -> void:
	player.velocity = dir * spd * delta
	player.update_velocity()
	if !vault_ray_cast_down.is_colliding(): transition.emit("IdlePlayerState")
