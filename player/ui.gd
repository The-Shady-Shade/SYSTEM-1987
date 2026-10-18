class_name UI extends Control

@export var player: Player
@export var light_bar: TextureProgressBar

func _process(_delta: float) -> void:
	light_bar.value = snappedf(player.light_detector.light, 0.1)
	#light_bar.tint_under.a = player.light_detector.light
	#light_bar.tint_progress.a = player.light_detector.light
	light_bar.visible = light_bar.value > 0.0
