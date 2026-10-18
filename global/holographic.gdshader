shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never, blend_add, shadows_disabled;

uniform vec3 glow_color : source_color = vec3(0.35, 0.95, 0.92);
uniform float fresnel_power : hint_range(0.5, 6.0) = 1.2;
uniform float base_alpha : hint_range(0.0, 1.0) = 0.20;
uniform float rim_strength : hint_range(0.0, 4.0) = 2.0;

uniform float edge_strength : hint_range(0.0, 4.0) = 1.4;
uniform float edge_start : hint_range(0.0, 1.0) = 0.55;

uniform float scanline_count : hint_range(0.0, 400.0) = 160.0;
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.22;
uniform float scanline_speed : hint_range(-2.0, 2.0) = 0.25;

uniform float flicker_strength : hint_range(0.0, 0.5) = 0.05;

varying vec3 v_normal_view;
varying vec3 v_to_camera;

void vertex() {
	v_normal_view = NORMAL;
	v_to_camera = -(MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 normal = normalize(v_normal_view);
	vec3 view_dir = normalize(v_to_camera);
	
	float facing = abs(dot(normal, view_dir));
	float fresnel = pow(1.0 - clamp(facing, 0.0, 1.0), fresnel_power);
	
	float scan = sin((SCREEN_UV.y + TIME * scanline_speed) * scanline_count) * 0.5 + 0.5;
	float flicker = 1.0 - flicker_strength * fract(sin(TIME * 11.0) * 43758.5453);
	
	float edge = smoothstep(edge_start, 1.0, fresnel) * edge_strength;
	float intensity = (base_alpha + fresnel * rim_strength + edge) * (1.0 - scanline_strength * scan) * flicker;
	intensity = max(intensity, 0.0);
	
	ALBEDO = glow_color * intensity;
	ALPHA = clamp(intensity, 0.0, 1.0);
}