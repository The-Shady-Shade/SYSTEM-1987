@tool
class_name SecurityDrone extends Security

@export var mesh: Node3D = null
@export var translation: Vector3 = Vector3.ZERO
@export var move_timer: float = 4.0
@export var wait_timer: float = 1.0
@onready var initial_position: Vector3 = global_position
@onready var previous_position: Vector3 = global_position
var tween: Tween = null
var time: float = 0.0

func _ready() -> void:
	if Engine.is_editor_hint(): return
	detection_timer.timeout.connect(on_detection_timer_timeout)
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "global_position", initial_position + translation, move_timer).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(wait_timer)
	tween.tween_property(self, "global_position", initial_position, move_timer).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(wait_timer)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	time += delta
	if alert: mesh.look_at(GameManager.player.global_position)
	else:
		var dir: Vector3 = global_position - previous_position
		previous_position = global_position
		if dir.length_squared() > 0.0001: mesh.look_at(mesh.global_position + dir.normalized())
	mesh.position = Vector3.UP * sin(time * 1.0) * 0.5

func hack() -> void: pass

func _func_godot_apply_properties(properties: Dictionary) -> void:
	translation = properties["translation"]
	move_timer = properties["move_timer"]
	wait_timer = properties["wait_timer"]
