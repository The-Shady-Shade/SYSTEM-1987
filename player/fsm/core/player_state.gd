@abstract class_name PlayerState extends Node

@warning_ignore("unused_signal")
signal transition(new_state_name: StringName)

@export var spd: float = 5.0
@export var acc: float = 10.0
var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player

func enter(_previous_state: PlayerState) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass 
