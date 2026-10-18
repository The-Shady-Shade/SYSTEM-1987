extends Area3D

func _ready() -> void: body_entered.connect(on_body_entered)
func on_body_entered(_body: Node3D) -> void: GameManager.player.kill()
