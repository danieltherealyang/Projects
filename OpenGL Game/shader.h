#ifndef SHADER_H
#define SHADER_H

#include "gl.h"

class Shader {
    private:
        GLuint m_shaderProgram;
    public:
        Shader(const char* vertexPath, const char* fragmentPath);
        void useProgram() const;
        GLuint getProgram() const;
};

#endif