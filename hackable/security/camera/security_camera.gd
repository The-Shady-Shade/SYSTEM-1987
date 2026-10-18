class_name SecurityCamera extends Security

@export var pivot: Node3D = null
@onready var initial_rotation: Vector3 = pivot.global_rotation

func _physics_process(_delta: float) -> void:
	if alert: pivot.look_at(GameManager.player.global_position)
	else: pivot.global_rotation = initial_rotation + Vector3.UP * sin(Time.get_ticks_msec() / 1000.0 * 1.0) * PI / 4

func hack() -> void: pass
