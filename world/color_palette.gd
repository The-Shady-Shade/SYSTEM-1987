@tool
extends MeshInstance3D

@export var colors: Array[Color] = []

func _ready():
	var gradient_texture: GradientTexture1D = GradientTexture1D.new()
	gradient_texture.gradient = generate_gradient()
	material_override.set_shader_parameter("palette", gradient_texture)
	#if !Engine.is_editor_hint(): visible = true

func generate_gradient() -> Gradient:
	var gradient: Gradient = Gradient.new()
	
	for point: int in gradient.get_point_count() - 1: gradient.remove_point(0)
	gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	
	for color_idx: int in colors.size(): gradient.add_point(color_idx / 16.0, colors[color_idx])
	gradient.remove_point(0)
	
	return gradient
