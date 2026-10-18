@tool
class_name MoverDoor extends Mover

func _ready() -> void:
	hacked.connect(on_hacked)
	toggle_activity(active)
	sync_to_physics = false

func _process(delta: float) -> void:
	constant_linear_velocity = translation.normalized() * translation.length() * delta
	move_and_collide(constant_linear_velocity)
	if global_position >= initial_position + translation: toggle_activity(false)

func on_hacked() -> void: toggle_activity(true)

func _func_godot_apply_properties(properties: Dictionary) -> void:
	target_name = properties["target_name"]
	active = properties["active"]
	translation = properties["translation"]
	
