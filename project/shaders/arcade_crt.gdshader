// Based on: https://www.shadertoy.com/view/Ms23DR
shader_type spatial;

global uniform bool CRT_ENABLED;
global uniform float BRIGHTNESS;

uniform sampler2D screen_texture : repeat_disable, filter_nearest;

// Loosely based on postprocessing shader by inigo quilez, License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// Modified to work as a spatial so it can be applied to a viewport in a 3D scene

vec2 curve(vec2 uv) {
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;	
	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv *0.92 + 0.04;
	return uv;
}

void fragment( ) {
	vec3 OutputColor;
	if (CRT_ENABLED) {
	    vec2 uv = curve(UV);
		if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0)
		    discard;
		
	    vec3 oricol = texture( screen_texture, vec2(UV.x,UV.y) ).xyz;
		float x = sin(0.3*TIME+uv.y*21.0)*sin(0.7*TIME+uv.y*29.0)*sin(0.3+0.33*TIME+uv.y*31.0)*0.0017;

	    vec3 col;
	    col.r = texture(screen_texture,vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
	    col.g = texture(screen_texture,vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
	    col.b = texture(screen_texture,vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
	    col.r += 0.08*texture(screen_texture,0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
	    col.g += 0.05*texture(screen_texture,0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
	    col.b += 0.08*texture(screen_texture,0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

	    col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

	    float vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
		col *= vec3(pow(max(vig, 0.0),0.3));

	    col *= vec3(0.95,1.05,0.95);
		col *= 2.8;

		// Original shader flickered, lets do a scanline warp like when CRTS are Desynced
		float scan_pos = fract(TIME * 0.12);
		float scan_dist = abs(uv.y - scan_pos);
		float scans = 1.0 - smoothstep(0.0, 0.025, scan_dist);

		float wrap = scans * 0.04;

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
			
		OutputColor = col;
	} else {
		OutputColor = texture( screen_texture, vec2(UV.x,UV.y) ).xyz;
	}
	OutputColor *= clamp(BRIGHTNESS, 1.0, 3.0);
	ALBEDO = OutputColor;
}