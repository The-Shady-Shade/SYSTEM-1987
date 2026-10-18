extends Node

var player: Player

var death_screen_path: String = "uid://cutg4l5fhp3oh"
var ending_path: String = ""

var maps: Array[String] = ["uid://buo1730adb02i", "uid://bxai6eaxy34eg"]
var map_idx: int = 0

var camera_shake: bool = true
var mouse_sensitivity: float = 0.1

func map_transition() -> void:
	map_idx += 1
	if map_idx == maps.size(): SceneTransition.change_scene(ending_path)
	else: SceneTransition.change_scene(maps[map_idx])
