shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    vec4 final_color = tex; // default: original pixel

    // if pixel is transparent, check neighbors
    if (tex.a < 0.1) {
        vec2 px = TEXTURE_PIXEL_SIZE;

        // check 4 neighbors
        vec4 n1 = texture(TEXTURE, UV + vec2(px.x, 0));
        vec4 n2 = texture(TEXTURE, UV + vec2(-px.x, 0));
        vec4 n3 = texture(TEXTURE, UV + vec2(0, px.y));
        vec4 n4 = texture(TEXTURE, UV + vec2(0, -px.y));

        vec4 n5 = texture(TEXTURE, UV + vec2(px.x, px.y));
		vec4 n6 = texture(TEXTURE, UV + vec2(-px.x, px.y));
		vec4 n7 = texture(TEXTURE, UV + vec2(px.x, -px.y));
		vec4 n8 = texture(TEXTURE, UV + vec2(-px.x, -px.y));

		if (n1.a > 0.1 || n2.a > 0.1 || n3.a > 0.1 || n4.a > 0.1 ||
		    n5.a > 0.1 || n6.a > 0.1 || n7.a > 0.1 || n8.a > 0.1) {
		    final_color = outline_color;
		}
    }

    COLOR = final_color;
}