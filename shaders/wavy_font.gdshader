shader_type canvas_item;

uniform float wave_strength = 2.0;
uniform float wave_speed = 1.5;
uniform float wave_frequency = 6.0;

void vertex() {
    VERTEX.y += sin(VERTEX.x * wave_frequency + TIME * wave_speed) * wave_strength;
}
