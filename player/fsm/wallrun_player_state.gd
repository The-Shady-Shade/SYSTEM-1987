class_name WallrunPlayerState extends PlayerState

@export var shape_cast_wallrun_left: ShapeCast3D
@export var shape_cast_wallrun_right: ShapeCast3D
var dir: Vector3
var wall_normal: Vector3
var angle_threshold: float = -0.75

func enter(_previous_state: PlayerState) -> void:
	if shape_cast_wallrun_left.is_colliding():
		player.previous_wallrun_wall = shape_cast_wallrun_left.get_collider_rid(0)
		wall_normal = shape_cast_wallrun_left.get_collision_normal(0)
		dir = wall_normal.cross(Vector3.UP).normalized()
	elif shape_cast_wallrun_right.is_colliding():
		player.previous_wallrun_wall = shape_cast_wallrun_right.get_collider_rid(0)
		wall_normal = shape_cast_wallrun_right.get_collision_normal(0)
		dir = wall_normal.cross(Vector3.UP).normalized()
	
	if dir.dot(player.global_transform.basis.z) > 0.0: dir = -dir

func update(delta: float) -> void:
	player.velocity = lerp(player.velocity, dir * spd, acc * delta)
	player.update_gravity(delta)
	player.update_velocity()
	
	camera_tilt(delta)
	check_camera_dir()
	
	if Input.is_action_just_pressed("jump"): transition.emit("JumpPlayerState")
	if shape_cast_wallrun_left.is_colliding() || shape_cast_wallrun_right.is_colliding(): transition.emit("FallPlayerState")
	if player.is_on_floor(): transition.emit("IdlePlayerState")

func camera_tilt(delta: float) -> void:
	var transition_spd: float = 5.0
	var transition_progress: float = 0.0
	var initial_tilt: Vector3 = player.camera.rotation
	var target_tilt: Vector3 = Vector3.ZERO
	
	transition_progress += transition_spd * delta
	transition_progress = clamp(transition_progress, 0.0, 1.0)

	if roundi(wall_normal.x) == -1: target_tilt.z = -dir.z * 0.2
	elif roundi(wall_normal.x) == 1: target_tilt.z = dir.z * 0.2
	elif roundi(wall_normal.z) == -1: target_tilt.z = dir.x * 0.2
	elif roundi(wall_normal.z) == 1: target_tilt.z = -dir.x * 0.2
	
	player.camera.rotation.z = 0.0
	player.camera.rotation = initial_tilt.slerp(target_tilt, transition_progress)

func check_camera_dir() -> void:
	var camera_dir: Vector3 = -player.camera.global_transform.basis.z.normalized()
	var dot_product: float = camera_dir.dot(dir)
	if dot_product < angle_threshold:
		dir = -dir
		player.velocity = Vector3.ZERO
