#include "vao.h"

#include <iostream>
void VAO::generate() {
    glGenVertexArrays(1, &m_vao);
}

VAO::~VAO() {
    glDeleteVertexArrays(1, &m_vao);
}

void VAO::setAttribute(GLuint index, GLint length, int stride, void* offset) {
    glVertexAttribPointer(index, length, GL_FLOAT, GL_FALSE, stride, offset);
    glEnableVertexArrayAttrib(m_vao, index);
}

void VAO::bind() {
    glBindVertexArray(m_vao);
}