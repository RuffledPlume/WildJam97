shader_type canvas_item;

uniform float curvature : hint_range(0.0, 10.0, 0.1) = 4.0;
uniform sampler2D screen_texture : hint_screen_texture;
uniform vec4 border_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

vec2 curve_uv(vec2 uv) {
	uv = uv * 2.0 - 1.0;
	vec2 offset = abs(uv.yx) / curvature;
	uv = uv + uv * offset * offset;
	uv = uv * 0.5 + 0.5;
	return uv;
}

void fragment() {
	vec2 uv = curve_uv(SCREEN_UV);

	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = border_color;
	} else {
		vec3 col = texture(screen_texture, uv).rgb;
	
		float scan_pos = fract(TIME * 0.12);
		float scan_dist = abs(uv.y - scan_pos);
		float scans = 1.0 - smoothstep(0.0, 0.025, scan_dist);

		float wrap = scans * 0.02;

		vec2 scan_uv = uv;
		scan_uv.x = fract(scan_uv.x + wrap);

		float chroma = 0.003;
		vec3 scan_col;
		scan_col.r = texture(screen_texture, scan_uv + vec2(chroma, 0.0)).r;
		scan_col.g = texture(screen_texture, scan_uv).g;
		scan_col.b = texture(screen_texture, scan_uv - vec2(chroma, 0.0)).b;

		col = mix(col, scan_col, scans);
		col *= 1.0 + 0.01 * sin(110.0 * TIME);
		col*=1.0-0.65*vec3(clamp((mod(FRAGCOORD.x, 2.0)-1.0)*2.0,0.0,1.0));
		
		COLOR = vec4(col, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
