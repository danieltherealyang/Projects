#include "assets.h"
#include <iostream>

float m_cubeVertex[] = {
    -0.5f, 0.5f, -0.5f, 0.5f, 0.5f, -0.5f, 0.5f, 0.5f, 0.5f, -0.5f, 0.5f, 0.5f,
    -0.5f, -0.5f, -0.5f, 0.5f, -0.5f, -0.5f, 0.5f, -0.5f, 0.5f, -0.5f, -0.5f, 0.5f
};

unsigned int m_cubeIndices[] = {
    0, 1, 2, 0, 2, 3, //top
    0, 3, 4, 3, 4, 7, //left
    1, 2, 5, 2, 5, 6, //right
    2, 3, 6, 3, 6, 7, //front
    0, 1, 4, 1, 4, 5, //back
    4, 5, 6, 4, 6, 7
};

Assets::Assets() {
    m_vao.generate();
    m_vbo.generate();
    m_ebo.generate();
}

float* Assets::getCubeVertex() {
    return m_cubeVertex;
}

unsigned int* Assets::getCubeIndex() {
    return m_cubeIndices;
}

void Assets::loadCube() {
    m_vao.bind();
    m_vbo.bind();
    m_vbo.load(m_cubeVertex, sizeof(m_cubeVertex));
    m_ebo.bind();
    m_ebo.load(m_cubeIndices, sizeof(m_cubeIndices));
    m_vao.setAttribute(0, 3, 3 * sizeof(float), (void*) 0);
}

void Assets::draw() {
    m_vao.bind();
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
}