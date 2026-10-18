@abstract class_name Mover extends AnimatableBody3D
@warning_ignore("unused_signal")
signal hacked

@export var target_name: String = ""
@export var active: bool = false
@export var translation: Vector3 = Vector3.ZERO
@onready var initial_position: Vector3 = global_position

func toggle_activity(activity: bool) -> void:
	active = activity
	set_process(activity)

@abstract func on_hacked() -> void
