class_name PlayerStateMachine extends Node

@export var state: PlayerState
var states: Dictionary = {}

func _ready() -> void:
	for child: Node in get_children():
		if child is PlayerState:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node.")
			
	await owner.ready
	state.enter(state)
	
func _process(delta: float) -> void:
	state.update(delta)
	
func _physics_proceess(delta: float) -> void:
	state.physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		state.exit()
		new_state.enter(state)
		state = new_state
	else:
		push_warning("State doesn't exist.")
