#ifndef WINDOW_H
#define WINDOW_H

#include "gl.h"
#include "headers/glfw3.h"

class Renderer;

class Window {
    private:
        GLFWwindow* m_window;
    public:
        Window(Renderer* renderer);
        void init();
        void loop();
        GLFWwindow* get();
};

#endif