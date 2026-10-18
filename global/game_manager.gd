extends Node

var boot: bool = false
var maps: Array[String] = ["uid://buo1730adb02i", "uid://bxai6eaxy34eg", "uid://c4l2ejxcd5p58"]
var map_idx: int = 0
var ending_path: String = "uid://dhes3uiehem62"

var player: Player

var mouse_sensitivity: float = 0.1
var camera_shake: bool = true

func map_transition() -> void:
	if get_tree().current_scene.has_node("MapTransitionSound"): get_tree().current_scene.get_node("MapTransitionSound").play()
	map_idx += 1
	if map_idx >= maps.size(): SceneTransition.change_scene(ending_path)
	else: SceneTransition.change_scene(maps[map_idx])
