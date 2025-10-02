shader_type canvas_item;

uniform int tint_color : hint_range(0, 2); // 0=red, 1=green, 2=blue
uniform float strength : hint_range(0.0, 1.0) = 0.5; // how strong the tint is
uniform float tolerance : hint_range(0.0, 0.05) = 0.01; // tolerance for float precision

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // define target grayscale colors
    vec3 c3 = vec3(0.278, 0.549, 0.749); // #bdbdbd

    // choose tint
    vec3 tint = vec3(0.0);
    if (tint_color == 0) {
        tint = vec3(1.0, 0.0, 0.0); // red
    } else if (tint_color == 1) {
        tint = vec3(0.0, 1.0, 0.0); // green
    } else if (tint_color == 2) {
        tint = vec3(0.0, 0.0, 1.0); // blue
    }

    // check if the current pixel matches any of the target colors
    bool match = false;
    if (distance(tex.rgb, c3) < tolerance) match = true;

    // apply tint if matched
    if (match) {
        tex.rgb = mix(tex.rgb, tint, strength);
    }

    COLOR = tex;
}
