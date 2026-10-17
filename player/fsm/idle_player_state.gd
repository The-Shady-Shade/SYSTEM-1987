class_name IdlePlayerState extends PlayerState

func enter(_previous_state: PlayerState) -> void:
	player.previous_vault_wall = player.get_rid()
	player.new_vault_wall = player.get_rid()

func update(delta: float) -> void:
	player.update_movement(spd, acc, delta)
	player.update_gravity(delta)
	player.update_velocity()
	
	if player.velocity.length() >= 0.1 && player.is_on_floor(): transition.emit("WalkPlayerState")
	
	if Input.is_action_just_pressed("jump") && player.is_on_floor(): transition.emit("JumpPlayerState")
	if !player.is_on_floor(): transition.emit("FallPlayerState")
