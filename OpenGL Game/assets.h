/*
ASSETS CLASS DESCRIPTION;
This class will manage all vertices, buffers, and textures.
*/
#ifndef ASSETS_H
#define ASSETS_H

#include "shader.h"
#include "vao.h"
#include "vbo.h"
#include "ebo.h"

class Assets {
    private:
        VAO m_vao;
        VBO m_vbo;
        EBO m_ebo;
    public:
        Assets();
        float* getCubeVertex();
        unsigned int* getCubeIndex();
        void loadCube();
        void draw();
};

#endif