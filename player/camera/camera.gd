extends Camera3D

@export var camera_pivot: Node3D = null
@export_group("Shake Stats")
@export var noise_texture: NoiseTexture2D
@export var noise_spd: float = 50.0
@export var trauma_reduction_rate: float = 1.0
@export var rotation_max: Vector3 = Vector3(10.0, 10.0, 5.0)
@onready var initial_rotation: Vector3 = rotation_degrees
var trauma: float = 0.0
var time: float = 0.0
@export_group("Recoil Stats")
@export var snap_amount: float = 10.0
@export var recoil_spd: float = 20.0
var target_rotation: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	time += delta
	trauma = max(trauma - trauma_reduction_rate * delta, 0.0)
	rotation_degrees.x += rotation_max.x * get_shake_intensity() * get_noise_from_seed(0)
	rotation_degrees.y += rotation_max.y * get_shake_intensity() * get_noise_from_seed(1)
	rotation_degrees.z += rotation_max.z * get_shake_intensity() * get_noise_from_seed(2)

func _physics_process(delta: float) -> void:
	target_rotation = lerp(target_rotation, Vector3.ZERO, recoil_spd * delta)
	rotation_degrees = lerp(rotation_degrees, target_rotation, snap_amount * delta)

func add_recoil(recoil_amount: Vector3) -> void:
	target_rotation += Vector3(randf_range(recoil_amount.x, recoil_amount.x * 2.0), randf_range(recoil_amount.y, recoil_amount.y * 2.0), randf_range(-recoil_amount.z, recoil_amount.z))

func add_trauma(trauma_amount: float) -> void:
	if !GameManager.camera_shake: return
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(idx: int) -> float:
	noise_texture.noise.seed = idx
	return noise_texture.noise.get_noise_1d(time * noise_spd)
