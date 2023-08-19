shader_type canvas_item;

/* Palette swap shader. Faction's colours stored in 'colours', a 5 faction * 8
colours * vec4 array. For each pixel in sprite, loop through the 8 colours of 
the original sprite's palette and check if pixel color similar via 'tol'.
If it's similar, swap it to the corresponding replace palette colour. Low precision
used throughout for performance. */

const lowp vec4 colours[40] = lowp vec4[40] (
	vec4(0.2235, 0.4706, 0.6588, 1.0000), //pawn left arm
    vec4(0.2235, 0.2784, 0.4706, 1.0000), //pawn upper torso
    vec4(0.1804, 0.2392, 0.4392, 1.0000), //pawn lower torso
    vec4(0.2784, 0.5176, 0.6980, 1.0000), //knight light blue
    vec4(0.1961, 0.2353, 0.6784, 1.0000), //bishop lower torso
    vec4(0.2902, 0.3176, 0.6275, 1.0000), //bishop hat
    vec4(0.1961, 0.2235, 0.5412, 1.0000), //bishop middle torso
    vec4(0.1804, 0.2392, 0.4392, 1.0000), //rook lower torso
	vec4(0.7608, 0.1922, 0.1922, 1.0000), //pawn left arm
    vec4(0.7294, 0.2235, 0.2235, 1.0000), //pawn upper torso
    vec4(0.5765, 0.0824, 0.0824, 1.0000), //pawn lower torso
    vec4(0.8824, 0.2235, 0.2235, 1.0000), //knight light blue
    vec4(0.6941, 0.1725, 0.1725, 1.0000), //bishop lower torso
    vec4(0.6275, 0.2471, 0.2471, 1.0000), //bishop hat
    vec4(0.6784, 0.0941, 0.0941, 1.0000), //bishop middle torso
    vec4(0.6275, 0.2471, 0.2471, 1.0000), //rook lower torso
	vec4(0.2902, 0.4745, 0.1216, 1.0000), //pawn left arm
    vec4(0.2706, 0.3725, 0.1765, 1.0000), //pawn upper torso
    vec4(0.1922, 0.3176, 0.2039, 1.0000), //pawn lower torso
    vec4(0.3608, 0.5725, 0.1647, 1.0000), //knight light blue
    vec4(0.2588, 0.5098, 0.0275, 1.0000), //bishop lower torso
    vec4(0.2941, 0.4118, 0.1843, 1.0000), //bishop hat
    vec4(0.2353, 0.4078, 0.0784, 1.0000), //bishop middle torso
    vec4(0.1137, 0.2196, 0.1255, 1.0000), //rook lower torso
	vec4(0.9843, 0.9216, 0.2039, 1.0000), //pawn left arm
    vec4(0.7490, 0.7020, 0.2000, 1.0000), //pawn upper torso
    vec4(0.7490, 0.7020, 0.2000, 1.0000), //pawn lower torso
    vec4(0.8784, 0.8275, 0.2588, 1.0000), //knight light blue
    vec4(0.5373, 0.5059, 0.1216, 1.0000), //bishop lower torso
    vec4(0.6275, 0.6235, 0.2902, 1.0000), //bishop hat
    vec4(0.9137, 0.7373, 0.0941, 1.0000), //bishop middle torso
    vec4(0.6941, 0.6627, 0.3059, 1.0000), //rook lower torso
	vec4(0.2549, 0.2510, 0.2510, 1.0000), //pawn left arm
    vec4(0.1216, 0.1294, 0.1373, 1.0000), //pawn upper torso
    vec4(0.1137, 0.1098, 0.1529, 1.0000), //pawn lower torso
    vec4(0.4941, 0.4667, 0.5098, 1.0000), //knight light blue
    vec4(0.1490, 0.0902, 0.1882, 1.0000), //bishop lower torso
    vec4(0.1216, 0.1294, 0.1373, 1.0000), //bishop hat
    vec4(0.0863, 0.0392, 0.1176, 1.0000), //bishop middle torso
    vec4(0.1529, 0.1255, 0.1255, 1.0000)  //rook lower torso
);

uniform float tol;
uniform int original_palette_num;
uniform int replace_palette_num;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    for (int i = 0; i < 8; i++) {
		bool replace = (distance(original_color, colours[(8 * original_palette_num) + i]) <= tol);
		if (replace) {
			COLOR = colours[(8 * replace_palette_num) + i];
		}
	}
}