#version 330 core
layout (location = 0) in vec3 vertex

void main() {
    position = vec4(vertex.x, vertex.y, vertex.z, 1.0);
}