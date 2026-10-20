extends Node

@export var winter_ai: AudioStreamPlayer = null
@export var booting_up: AudioStreamPlayer = null

func _ready() -> void:
	on_transition_finished()
	winter_ai.finished.connect(on_transition_finished)
	booting_up.finished.connect(on_transition_finished)
	SceneTransition.transition_finished.connect(on_transition_finished)

func on_transition_finished() -> void:
	if get_tree().current_scene is Map and !winter_ai.playing:
		booting_up.stop()
		winter_ai.play()
	if get_tree().current_scene is Menu and !booting_up.playing:
		winter_ai.stop()
		booting_up.play()
