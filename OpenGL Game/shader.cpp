#include "shader.h"
#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;

Shader::Shader(const char* vertexPath, const char* fragmentPath) {
    ifstream vertexSource;
    ifstream fragmentSource;
    string vertexString;
    string fragmentString;

    try {
        vertexSource.open(vertexPath);
        fragmentSource.open(fragmentPath);

        stringstream vertexStream, fragmentStream;
        vertexStream << vertexSource.rdbuf();
        fragmentStream << fragmentSource.rdbuf();

        vertexSource.close();
        fragmentSource.close();

        vertexString = vertexStream.str();
        fragmentString = fragmentStream.str();
    } catch (ifstream::failure e) {
        cout << "ERROR: SHADERS FAILED TO READ" << endl;
    }

    GLint success;

    const char* vertexShaderSource = vertexString.c_str();
    const char* fragmentShaderSource = fragmentString.c_str();

    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        cout << "ERROR: VERTEX SHADER FAILED TO COMPILE" << endl;
    }

    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        cout << "ERROR: FRAGMENT SHADER FAILED TO COMPILE" << endl;
    }

    m_shaderProgram = glCreateProgram();
    glAttachShader(m_shaderProgram, vertexShader);
    glAttachShader(m_shaderProgram, fragmentShader);
    glLinkProgram(m_shaderProgram);

    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
}

void Shader::useProgram() const {
    glUseProgram(m_shaderProgram);
}

GLuint Shader::getProgram() const {
    return m_shaderProgram;
}