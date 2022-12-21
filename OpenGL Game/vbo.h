#ifndef VBO_H
#define VBO_H

#include "gl.h"

class VBO {
    private:
        GLuint m_vbo;
    public:
        void generate();
        ~VBO();
        void load(float vertices[], size_t size);
        void bind();
};

#endif