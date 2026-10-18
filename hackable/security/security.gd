@abstract class_name Security extends Hackable

@export_group("Detection")
@export var detection_area: Area3D = null
@export var obstacle_ray_cast: RayCast3D = null
@export var detection_light: SpotLight3D = null
@export var detection_timer: Timer = null
var alert: bool = false
@export_group("SFX")
@export var alert_sound: AudioStreamPlayer = null

func _ready() -> void: detection_timer.timeout.connect(on_detection_timer_timeout)

func on_detection_timer_timeout() -> void:
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
