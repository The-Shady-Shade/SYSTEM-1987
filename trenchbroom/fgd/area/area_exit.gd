extends Area3D

var active: bool = true

func _ready() -> void: body_entered.connect(on_body_entered)
func on_body_entered(_body: Node3D) -> void:
	if !active: return
	active = false
	GameManager.map_transition()
