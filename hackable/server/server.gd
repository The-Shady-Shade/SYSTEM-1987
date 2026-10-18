@tool
class_name Server extends Hackable

@export var targets: Array[Node3D] = []
@export var selection_instance: MeshInstance3D
@export var hack_key: Sprite3D
@export var selection_sound: AudioStreamPlayer
@export var hack_sound: AudioStreamPlayer
var active: bool = true

func _ready() -> void: toggle_selection(false, true)

func hack() -> void:
	if !active: return
	for target: Node3D in targets: target.hacked.emit()
	hack_sound.pitch_scale = randf_range(0.85, 1.15)
	hack_sound.play()
	toggle_activity(false)

func toggle_selection(selection: bool, force: bool = false) -> void:
	if selected == selection && !force: return
	selected = selection
	selection_instance.visible = selection
	hack_key.visible = selection
	if selection:
		selection_sound.pitch_scale = randf_range(0.85, 1.15)
		selection_sound.play()
	
func toggle_activity(activity: bool) -> void:
	active = activity
	toggle_selection(false)
	set_process_input(activity)
	set_process(activity)
	set_physics_process(activity)

func _func_godot_apply_properties(properties: Dictionary) -> void:
	var target_name = properties["target_name"]
	for child: Node3D in get_parent().get_children():
		if child.has_signal("hacked"):
			if target_name == child.target_name: targets.append(child)
