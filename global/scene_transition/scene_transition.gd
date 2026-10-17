extends CanvasLayer

@export var dissolve_rect: ColorRect
@export var animation: AnimationPlayer
@onready var current_scene: Node = get_tree().root.get_child(-1)
var active: bool = false

func _ready() -> void:
	dissolve_rect.color = ProjectSettings.get_setting("application/boot_splash/bg_color")

func change_scene(scene_path: String) -> void:
	if active: return
	active = true
	change_scene_deffered.call_deferred(scene_path)

func change_scene_deffered(scene_path: String) -> void:
	animation.play_backwards("Dissolve")
	await animation.animation_finished
	current_scene.free()
	current_scene = ResourceLoader.load(scene_path).instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	animation.play("Dissolve")
	active = false
