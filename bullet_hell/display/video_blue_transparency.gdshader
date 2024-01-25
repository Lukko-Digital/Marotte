shader_type canvas_item;

uniform vec3 orange : source_color;

void fragment() {
    vec4 color = texture(TEXTURE, UV);

	if (abs(color.r - color.g) <= 0.1){
    	COLOR = vec4(color.rgr, color.r);
	}else{
		float fade_rate = color.r / orange.r;
		COLOR = vec4(color.rg, orange.b * fade_rate, 1.0 - (orange.b * fade_rate - color.b));
	}
}