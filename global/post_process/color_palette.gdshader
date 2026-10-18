shader_type spatial;
render_mode unshaded, cull_front, depth_test_disabled;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
const float lin = 0.454545;
const float srgb = 2.2;

group_uniforms Palette;
uniform sampler2D palette: source_color, filter_nearest, repeat_enable;
uniform float rows = 4.0; 
uniform float cols = 4.0;

group_uniforms Dither;
uniform float dither_size;
uniform float dither_amount: hint_range(0.0, 1.0);

float lerp(float val1, float val2, float mul) {
	return val1 + (val2 - val1) * clamp(mul, 0.0, 1.0);
}

vec3 get_srgb(vec3 xyz) {
	return vec3(pow(xyz.x, srgb), pow(xyz.y, srgb), pow(xyz.z, srgb));
}

vec3 get_linear(vec3 xyz) {
	return vec3(pow(xyz.x, lin), pow(xyz.y, lin), pow(xyz.z, lin));
}

float pick_color(float x, float y) {	
	x = mod(x, 1.0);
	y = mod(y, 1.0);
	
	x = clamp(floor(x * rows) / (cols * rows), 0.0, 250.0 / 256.0);
	y = clamp(floor(y * cols) / cols, 0.0, 250.0 / 256.0);
	
	return x + y;
}

vec3 dither(vec3 color, vec2 uv, vec2 screen_size) {
	color = get_linear(color);
	
	float dither = max(dither_size, 1.0);
	float f = 0.25 / rows;
	
	float a = floor(mod(uv.x * screen_size.x / dither, 2.0));
	float b = floor(mod(uv.y * screen_size.y / dither, 2.0));
	float c = mod(a + b , 2.0) + f;
	float d = rows * cols;
	
	color.r += lerp(-f, f, c);
	color = get_srgb(color);
	color = clamp(vec3(round(color.r * d) / d, round(color.g * d) / d, round(color.b * d) / d), 0.0, 1023.5 / 1024.0);
	
	return color;
}

void fragment() {
	float index = 0.0;
	
	vec4 tex = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	
	vec3 color = tex.rgb;
	color.r = lerp(color.r, dither(color, SCREEN_UV, VIEWPORT_SIZE).r, dither_amount);
	
	vec3 corr = get_linear(color.rgb);
	index = pick_color(corr.r, corr.g);
	
	vec3 palette_read = get_srgb(textureLod(palette, vec2(index, 0.0), 0.0).rgb);
	ALBEDO.rgb = palette_read;            
}