@abstract class_name Menu extends Control

@export var text_delay: float = 0.025
@export_group("SFX")
@export var text_sound: AudioStreamPlayer
@export var submit_sound: AudioStreamPlayer
@export var error_sound: AudioStreamPlayer

func type_line(label: RichTextLabel, line: String) -> void:
	for idx: int in range(line.length()):
		label.append_text(line.substr(idx, 1))
		if text_delay <= 0.0: continue
		text_sound.pitch_scale = randf_range(0.85, 1.15)
		text_sound.play()
		await get_tree().create_timer(text_delay).timeout
	label.append_text("\n")

func fade_in(node: Control, duration: float) -> void:
	node.show()
	node.modulate.a = 0.0

	var tween: Tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)

	await tween.finished
