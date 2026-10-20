class_name SecurityCamera extends Security

@export var pivot: Node3D = null
@onready var initial_rotation: Vector3 = pivot.global_rotation
var time: float = 0.0

func _physics_process(delta: float) -> void:
	time += delta
	if alert: pivot.look_at(GameManager.player.global_position)
	else: pivot.global_rotation = initial_rotation + Vector3.UP * sin(time * 1.0) * PI / 4

func hack() -> void: pass
