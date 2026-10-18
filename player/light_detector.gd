class_name LightDetector extends Node3D

@export var player: Player
@export var light_viewport: SubViewport
var light: float = 0.0

func _process(_delta: float) -> void:
	global_position = player.global_position
	var texture = light_viewport.get_texture()
	var color: Color = get_average_color(texture)
	light = color.get_luminance()
	#print(light)

func get_average_color(texture: ViewportTexture) -> Color:
	var image: Image = texture.get_image()
	image.resize(1, 1, Image.INTERPOLATE_LANCZOS)
	return image.get_pixel(0, 0)
