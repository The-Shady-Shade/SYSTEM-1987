class_name CameraPivot extends Node3D

@export var player: Player
@export var camera: Camera3D
@export var tilt_limit: float = deg_to_rad(89.0)
var mouse_rotation: Vector3 = Vector3.ZERO
var rotation_input: float = 0.0
var tilt_input: float = 0.0
@export_group("Recoil")
@export var snap_amount: float = 10.0
@export var recoil_spd: float = 20.0
var target_rotation: Vector3 = Vector3.ZERO
@export_group("Head Bob")
@export var head_bob_frequency: float = 2.0
@export var head_bob_amplitude: float = 0.04
var head_bob_time: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_rotation = player.rotation

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_input = -event.relative.x * GameManager.mouse_sensitivity
		tilt_input = -event.relative.y * GameManager.mouse_sensitivity
	if event is InputEventMouseButton && event.is_pressed(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, -tilt_limit, tilt_limit)
	mouse_rotation.y += rotation_input * delta
	
	rotation.x = mouse_rotation.x
	player.global_rotation.y = mouse_rotation.y
	
	rotation_input = 0.0
	tilt_input = 0.0
	
	head_bob_time += player.velocity.length() * (player.is_on_floor() as float) * delta
	camera.transform.origin = update_head_bob()
	
	target_rotation = lerp(target_rotation, Vector3.ZERO, recoil_spd * delta)
	rotation_degrees = lerp(rotation_degrees, target_rotation, snap_amount * delta)

func update_head_bob() -> Vector3:
	var head_bob_position = Vector3.ZERO
	head_bob_position.x = cos(head_bob_time * head_bob_frequency / 2) * head_bob_amplitude
	head_bob_position.y = sin(head_bob_time * head_bob_frequency) * head_bob_amplitude
	return head_bob_position

func add_recoil(recoil_amount: Vector3) -> void:
	target_rotation += Vector3(randf_range(recoil_amount.x, recoil_amount.x * 2.0), randf_range(recoil_amount.y, recoil_amount.y * 2.0), randf_range(-recoil_amount.z, recoil_amount.z))
