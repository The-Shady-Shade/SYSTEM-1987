class_name CameraPivot extends Node3D

@export var player: Player
@export var camera: Camera3D
@export var tilt_limit: float = deg_to_rad(89.0)
var mouse_rotation: Vector3 = Vector3.ZERO
var rotation_input: float = 0.0
var tilt_input: float = 0.0
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
	camera.transform.origin = head_bob()
	
	side_tilt(delta)

func head_bob() -> Vector3:
	var head_bob_position = position
	head_bob_position.x += cos(head_bob_time * head_bob_frequency / 2) * head_bob_amplitude
	head_bob_position.y += sin(head_bob_time * head_bob_frequency) * head_bob_amplitude
	return head_bob_position

func side_tilt(delta: float) -> void:
	var input_dir_x: float = Input.get_vector("left", "right", "forward", "backward").x
	rotation.z = lerp(rotation.z, -input_dir_x * 0.1, 5.0 * delta)
