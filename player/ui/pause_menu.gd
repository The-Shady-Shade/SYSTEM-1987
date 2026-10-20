extends CanvasLayer

@export var animation: AnimationPlayer
var pause: bool = false

func _ready() -> void:
	toggle_pause(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): toggle_pause(!pause)

func toggle_pause(new_state: bool) -> void:
	pause = new_state
	get_tree().paused = new_state
	visible = new_state
	@warning_ignore("standalone_ternary")
	animation.play("Blur") if new_state else animation.play_backwards("Blur")
	await animation.animation_finished
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if new_state else Input.MOUSE_MODE_CAPTURED
