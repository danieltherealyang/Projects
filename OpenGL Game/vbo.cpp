#include "vbo.h"
#include <iostream>

void VBO::generate() {
    glGenBuffers(1, &m_vbo);
}

VBO::~VBO() {
    glDeleteBuffers(1, &m_vbo);
}

void VBO::load(float vertices[], size_t size) {
    glBufferData(GL_ARRAY_BUFFER, size, vertices, GL_STATIC_DRAW);
}

void VBO::bind() {
    glBindBuffer(GL_ARRAY_BUFFER, m_vbo);
}