shader_type spatial;

uniform vec3 cube[8];
uniform float minBound : hint_range(-100, 100);
uniform float maxBound : hint_range(-100, 100);
uniform vec4 quat : source_color;

vec3 q_mul_vec(vec4 q, vec3 v) {
    return v + 2.0 * cross(q.xyz, cross(q.xyz, v) + q.w * v);
}

void vertex() {
    vec3 pos = q_mul_vec(quat, VERTEX); // Apply Tile Rotation before Lerping so the tile is in the correct orientation
    float xd = (pos.x - minBound) / (maxBound - minBound);
    float yd = (pos.y - minBound) / (maxBound - minBound);
    float zd = (pos.z - minBound) / (maxBound - minBound);
    
    vec3 c00 = cube[0] * (1.0 - xd) + cube[1] * xd;   // Back Plane
    vec3 c01 = cube[2] * (1.0 - xd) + cube[3] * xd;
    vec3 c10 = cube[4] * (1.0 - xd) + cube[5] * xd;   // Forward Plane
    vec3 c11 = cube[6] * (1.0 - xd) + cube[7] * xd;

    vec3 c0 = c00 * (1.0 - zd) + c10 * zd;
    vec3 c1 = c01 * (1.0 - zd) + c11 * zd;

    VERTEX = c0 * (1.0 - yd) + c1 * yd;

    // Rest of the shader code (omitted from the example for brevity)
}