class_name Player extends CharacterBody3D

@export var collision_shape: CollisionShape3D
@export var camera_pivot: Node3D
@export var camera: Camera3D
@export var interaction_ray_cast: RayCast3D
var selected_computer: Computer = null
@export var light_detector: LightDetector
@export_group("Movement")
@export var grv: float = 20.0
var previous_vault_wall: RID
var new_vault_wall: RID

func _ready() -> void:
	GameManager.player = self

func _input(event: InputEvent) -> void:
	if selected_computer:
		if event.is_action_pressed("interact") && selected_computer.selected && selected_computer.active:
			selected_computer.interact()
			selected_computer = null

func _process(_delta: float) -> void:
	if interaction_ray_cast.is_colliding():
		if !is_instance_valid(interaction_ray_cast.get_collider()): return
		var collider: Node3D = interaction_ray_cast.get_collider().get_parent()
		if collider is Computer:
			if collider.active:
				if !selected_computer: selected_computer = collider
				elif selected_computer != collider:
					selected_computer.toggle_selection(false)
					selected_computer = collider
				selected_computer.toggle_selection(true)
		elif selected_computer:
			selected_computer.toggle_selection(false)
			selected_computer = null
	elif selected_computer:
		selected_computer.toggle_selection(false)
		selected_computer = null

func update_movement(spd: float, acc: float, delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var dir: Vector3 = (global_basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	velocity.x = lerp(velocity.x, dir.x * spd, acc * delta)
	velocity.z = lerp(velocity.z, dir.z * spd, acc * delta)

func update_gravity(delta: float) -> void: velocity.y -= grv * delta
func update_velocity() -> void: move_and_slide()
