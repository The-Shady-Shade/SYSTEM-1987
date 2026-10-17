class_name UI extends Control

@export var player: Player
@export var light_bar: ProgressBar

func _process(_delta: float) -> void:
	light_bar.value = player.light_detector.light * 100.0
