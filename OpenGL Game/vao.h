#ifndef VAO_H
#define VAO_H

#include "gl.h"

class VAO {
    private:
        GLuint m_vao;
    public:
        void generate();
        ~VAO(); 
        void setAttribute(GLuint index, GLint length, int stride, void* offset);
        void bind();
};

#endif