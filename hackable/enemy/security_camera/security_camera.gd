class_name SecurityCamera extends Enemy

@export_group("Rotation")
@export var pivot: Node3D = null
@onready var initial_rotation: Vector3 = pivot.global_rotation
@export_group("Detection")
@export var detection_area: Area3D = null
@export var obstacle_ray_cast: RayCast3D = null
@export var detection_light: SpotLight3D = null
@export var detection_timer: Timer = null
var alert: bool = false
var active: bool = true
@export_group("SFX")
@export var alert_sound: AudioStreamPlayer = null

func _ready() -> void:
	detection_timer.timeout.connect(on_detection_timer_timeout)

func _process(_delta: float) -> void:
	if alert: pivot.look_at(GameManager.player.global_position)
	else: pivot.global_rotation = initial_rotation + Vector3.UP * sin(Time.get_ticks_msec() / 1000.0 * 1.0) * PI / 4

func hack() -> void:
	pass

func on_detection_timer_timeout() -> void:
	if !active:
		alert = false
		return
	
	if detection_area.has_overlapping_bodies():
		obstacle_ray_cast.look_at(GameManager.player.global_position, Vector3.UP)
		obstacle_ray_cast.force_raycast_update()
		if obstacle_ray_cast.is_colliding():
			if obstacle_ray_cast.get_collider() is Player:
				if alert: return
				alert_sound.pitch_scale = randf_range(0.85, 1.15)
				alert_sound.play()
				alert = true
				return
	
	alert = false
