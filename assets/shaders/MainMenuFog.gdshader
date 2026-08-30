shader_type canvas_item;

uniform sampler2D mask_texture;
uniform vec4 fog_color : source_color = vec4(0.75, 0.75, 0.75, 1.0);
uniform float fog_strength : hint_range(0.0, 1.0) = 0.22;
uniform float speed_1 : hint_range(0.0, 2.0) = 0.25;
uniform float speed_2 : hint_range(0.0, 2.0) = 0.18;

void fragment() {
	vec2 uv = UV;

	float wave1 = sin((uv.x * 8.0) + TIME * speed_1) * 0.5 + 0.5;
	float wave2 = sin((uv.x * 14.0) - TIME * speed_2) * 0.5 + 0.5;
	float fog = wave1 * 0.6 + wave2 * 0.4;

	float mask = texture(mask_texture, uv).r;

	float bottom_fade = smoothstep(1.0, 0.35, uv.y);
	float top_fade = smoothstep(0.0, 0.25, uv.y);

	float alpha = fog * mask * bottom_fade * top_fade * fog_strength;

	COLOR = vec4(fog_color.rgb, alpha);
}