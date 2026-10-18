class_name Player extends CharacterBody3D

@export var collision_shape: CollisionShape3D
@export var camera_pivot: Node3D
@export var camera: Camera3D
@export var light_detector: LightDetector
var detection_timer: float = 0.0
var dead: bool = false
@export_group("Movement")
@export var grv: float = 20.0
@export_group("Hacking")
@export var hack_ray_cast: RayCast3D
var selected_hackable: Hackable = null
@export_group("SFX")
@export var kill_sound: AudioStreamPlayer

func _ready() -> void:
	GameManager.player = self

func _input(event: InputEvent) -> void:
	if selected_hackable:
		if event.is_action_pressed("interact") && selected_hackable.active:
			selected_hackable.hack()
			selected_hackable = null

func _process(delta: float) -> void:
	if snapped(light_detector.light, 0.1) >= 1.0:
		detection_timer += delta
		if detection_timer >= 0.5: kill()
	else: detection_timer = 0.0
	
	if hack_ray_cast.is_colliding():
		if !is_instance_valid(hack_ray_cast.get_collider()): return
		var collider: Node3D = hack_ray_cast.get_collider().get_parent()
		if collider is Hackable:
			if collider.active:
				if !selected_hackable: selected_hackable = collider
				elif selected_hackable != collider:
					selected_hackable.toggle_selection(false)
					selected_hackable = collider
				selected_hackable.toggle_selection(true)
		elif selected_hackable:
			selected_hackable.toggle_selection(false)
			selected_hackable = null
	elif selected_hackable:
		selected_hackable.toggle_selection(false)
		selected_hackable = null

func update_movement(spd: float, acc: float, delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var dir: Vector3 = (global_basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	velocity.x = lerp(velocity.x, dir.x * spd, acc * delta)
	velocity.z = lerp(velocity.z, dir.z * spd, acc * delta)

func update_gravity(delta: float) -> void: velocity.y -= grv * delta
func update_velocity() -> void: move_and_slide()

func kill() -> void:
	if dead: return
	dead = true
	kill_sound.play()
	SceneTransition.change_scene(get_tree().current_scene.scene_file_path)
