#include "ebo.h"

void EBO::generate() {
    glGenBuffers(1, &m_ebo);
}

EBO::~EBO() {
    glDeleteBuffers(1, &m_ebo);
}

void EBO::load(unsigned int indices[], size_t size) {
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, size, indices, GL_STATIC_DRAW);
}

void EBO::bind() {
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_ebo);
}