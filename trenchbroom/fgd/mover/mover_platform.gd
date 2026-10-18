@tool
class_name MoverPlatform extends Mover

@export var move_timer: float = 2.0
@export var wait_timer: float = 0.5

func _ready() -> void:
	if Engine.is_editor_hint(): return
	hacked.connect(on_hacked)
	toggle_activity(active)
	move()

func move() -> void:
	if !active: return
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "global_position", initial_position + translation, move_timer).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(wait_timer)
	tween.tween_property(self, "global_position", initial_position, move_timer).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(wait_timer)

func on_hacked() -> void:
	toggle_activity(true)
	move()

func _func_godot_apply_properties(properties: Dictionary) -> void:
	target_name = properties["target_name"]
	active = properties["active"]
	translation = properties["translation"]
	move_timer = properties["move_timer"]
	wait_timer = properties["wait_timer"]
