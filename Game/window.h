#ifndef WINDOW_H
#define WINDOW_H

#include "headers/glfw3.h"
using namespace std;

class Window {
    private:
        GLuint m_vao;
        GLuint m_shaderProgram;
        GLFWwindow* m_window;
    public:
        Window(int width, int height, char* title, GLFWmonitor* monitor, GLFWwindow* share);
        ~Window();
        void init();
        void terminate();
        void start();
        void render();
        void createVertexObjects();
        void compileShaders();
};

#endif