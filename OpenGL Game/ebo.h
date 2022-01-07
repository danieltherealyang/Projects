#ifndef EBO_H
#define EBO_H

#include "gl.h"

class EBO {
    private:
        GLuint m_ebo;
    public:
        void generate();
        ~EBO();
        void load(unsigned int indices[], size_t size);
        void bind();
};

#endif