class_name WalkPlayerState extends PlayerState

func update(delta: float) -> void:
	player.update_movement(spd, acc, delta)
	player.update_gravity(delta)
	player.update_velocity()
	
	if player.velocity.length() == 0.0: transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("jump") && player.is_on_floor(): transition.emit("JumpPlayerState")
	if !player.is_on_floor(): transition.emit("FallPlayerState")
