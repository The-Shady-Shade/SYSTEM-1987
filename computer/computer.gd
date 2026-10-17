class_name Computer extends Node3D

@export var targets: Array[Node3D] = []
@export var selection_instance: MeshInstance3D
@export var selection_sound: AudioStreamPlayer
var selected: bool = false
var active: bool = true

func _ready() -> void: toggle_selection(false, true)

func interact() -> void:
	if !active: return
	toggle_activity(false)

func toggle_selection(selection: bool, force: bool = false) -> void:
	if selected == selection && !force: return
	selected = selection
	selection_instance.visible = selection
	if selection:
		selection_sound.pitch_scale = randf_range(0.85, 1.15)
		selection_sound.play()
	
func toggle_activity(activity: bool) -> void:
	active = activity
	toggle_selection(false)
	set_process_input(activity)
	set_process(activity)
	set_physics_process(activity)
