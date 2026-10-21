extends CanvasLayer

@export var settings_menu: SettingsMenu = null
@export var animation: AnimationPlayer = null
@export var pause_open_sound: AudioStreamPlayer = null
@export var pause_close_sound: AudioStreamPlayer = null
var pause: bool = false

func _ready() -> void:
	toggle_pause(false, true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): toggle_pause(!pause)

func toggle_pause(new_state: bool, force: bool = false) -> void:
	pause = new_state
	get_tree().paused = new_state
	
	if new_state:
		visible = new_state
		settings_menu.set_process(new_state)
		animation.play("Blur")
		if !force:
			pause_open_sound.pitch_scale = randf_range(0.85, 1.15)
			pause_open_sound.play()
			await animation.animation_finished
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		animation.play_backwards("Blur")
		if !force:
			pause_close_sound.pitch_scale = randf_range(0.85, 1.15)
			pause_close_sound.play()
			await animation.animation_finished
		visible = new_state
		settings_menu.set_process(new_state)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
