#include "headers/glad.h"
#include "shapes.h"
#include <iostream>
void loadCube(float x, float y, float z, float len) {
    float offset = len/2;
    float cube[] = {
        x - offset, y + offset, z, x + offset, y + offset, z, x + offset, y - offset, z, x - offset, y - offset, z,
        x - offset, y + offset, z - len, x + offset, y + offset, z - len, x + offset, y - offset, z - len, x - offset, y - offset, z - len
    };
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube), cube, GL_STATIC_DRAW);
}

void loadCubeElements() {
    int elements[] = {
        0, 1, 2, 0, 2, 3,
        4, 5, 6, 4, 6, 7,
        0, 3, 7, 0, 4, 7,
        1, 2, 6, 1, 5, 6,
        0, 1, 5, 0, 4, 5,
        2, 3, 7, 2, 6, 7
    };
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(elements), elements, GL_STATIC_DRAW);
}