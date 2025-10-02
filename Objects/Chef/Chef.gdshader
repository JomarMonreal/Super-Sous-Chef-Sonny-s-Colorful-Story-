shader_type canvas_item;

uniform int tint_color : hint_range(0, 5); // 0=red, 1=green, 2=blue, 3=yellow, 4=purple, 5=orange
uniform float strength : hint_range(0.0, 1.0) = 0.5; // how strong the tint is
uniform float tolerance : hint_range(0.0, 0.05) = 0.01; // tolerance for float precision

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // define target colors to match (grayscale examples)
    vec3 c1 = vec3(224.0/255.0); // #e0e0e0
    vec3 c2 = vec3(238.0/255.0); // #eeeeee
    vec3 c3 = vec3(189.0/255.0); // #bdbdbd

    // choose tint based on tint_color
    vec3 tint = vec3(0.0);
    if (tint_color == 0) {
        tint = vec3(1.0, 0.0, 0.0); // red
    } else if (tint_color == 1) {
        tint = vec3(0.0, 1.0, 0.0); // green
    } else if (tint_color == 2) {
        tint = vec3(0.0, 0.0, 1.0); // blue
    } else if (tint_color == 3) {
        tint = vec3(1.0, 1.0, 0.0); // yellow
    } else if (tint_color == 4) {
        tint = vec3(0.5, 0.0, 0.5); // purple
    } else if (tint_color == 5) {
        tint = vec3(1.0, 0.5, 0.0); // orange
    }

    // check if the current pixel matches any of the target colors
    bool match = false;
    if (distance(tex.rgb, c1) < tolerance) match = true;
    if (distance(tex.rgb, c2) < tolerance) match = true;
    if (distance(tex.rgb, c3) < tolerance) match = true;

    // apply tint if matched
    if (match) {
        tex.rgb = mix(tex.rgb, tint, strength);
    }

    COLOR = tex;
}
