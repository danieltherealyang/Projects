#include "window.h"
#include "renderer.h"
#include <iostream>

void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void mouse_callback(GLFWwindow* window, double xpos, double ypos);
void mouse_button_callback(GLFWwindow* window, int button, int action, int mods);
void processInput(GLFWwindow* window, Renderer* renderer);

float deltaTime = 0.0f;
float lastFrame = 0.0f;
float mouseX = (float) SCR_WIDTH/2;
float mouseY = (float) SCR_HEIGHT/2;
bool CURSOR_DISABLED = true;
Renderer* m_renderer;

Window::Window(Renderer* renderer) {
    m_renderer = renderer;
}

void Window::init() {
    glfwInit();
    
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 5);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    m_window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, TITLE, NULL, NULL);
    if (m_window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
    }

    glfwMakeContextCurrent(m_window);
    //GLFW CALLBACKS
    glfwSetFramebufferSizeCallback(m_window, framebuffer_size_callback);
    glfwSetCursorPosCallback(m_window, mouse_callback);
    glfwSetMouseButtonCallback(m_window, mouse_button_callback);
    glfwSetInputMode(m_window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
    if (glfwRawMouseMotionSupported())
        glfwSetInputMode(m_window, GLFW_RAW_MOUSE_MOTION, GLFW_TRUE);
}

void Window::loop() {
    while (!glfwWindowShouldClose(m_window)) {
        float currentFrame = glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;

        processInput(m_window, m_renderer);

        m_renderer->render();

        glfwSwapBuffers(m_window);
        glfwPollEvents();
    }

    glfwTerminate();
}

GLFWwindow* Window::get() {
    return m_window;
}

void processInput(GLFWwindow* window, Renderer* renderer) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS ||
    (glfwGetKey(window, GLFW_KEY_LEFT_CONTROL) == GLFW_PRESS && glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS)) {
        glfwSetWindowShouldClose(window, true);
    }

    if (glfwGetKey(window, GLFW_KEY_LEFT_CONTROL) == GLFW_PRESS &&
    glfwGetKey(window, GLFW_KEY_LEFT_ALT) == GLFW_PRESS) {
        glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_NORMAL);
        CURSOR_DISABLED = false;
    }

    if (glfwGetKey(window, GLFW_KEY_W) == GLFW_PRESS)
        renderer->camera->move(SPEED, 'F');
    if (glfwGetKey(window, GLFW_KEY_A) == GLFW_PRESS)
        renderer->camera->move(SPEED, 'L');
    if (glfwGetKey(window, GLFW_KEY_S) == GLFW_PRESS)
        renderer->camera->move(SPEED, 'B');
    if (glfwGetKey(window, GLFW_KEY_D) == GLFW_PRESS)
        renderer->camera->move(SPEED, 'R');
    if (glfwGetKey(window, GLFW_KEY_SPACE) == GLFW_PRESS)
        renderer->camera->move(SPEED, 'U');
    if (glfwGetKey(window, GLFW_KEY_X) == GLFW_PRESS)
        renderer->camera->move(SPEED, 'D');
}

void mouse_button_callback(GLFWwindow* window, int button, int action, int mods) {
    if (CURSOR_DISABLED == false && glfwGetWindowAttrib(window, GLFW_HOVERED) &&
        ((button == GLFW_MOUSE_BUTTON_LEFT && action == GLFW_PRESS) || 
        (button == GLFW_MOUSE_BUTTON_RIGHT && action == GLFW_PRESS))
    ) {
        glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED);
        CURSOR_DISABLED = true;
        glfwSetCursorPos(window, mouseX, mouseY);
    }
}

void mouse_callback(GLFWwindow* window, double xpos, double ypos) {
    float x_delta = xpos - mouseX;
    float y_delta = mouseY - ypos;
    if (CURSOR_DISABLED)
        glfwSetCursorPos(window, mouseX, mouseY);

    m_renderer->camera->incPitch(SENSITIVITY*y_delta);
    m_renderer->camera->incYaw(SENSITIVITY*x_delta);
    m_renderer->camera->updateDirection();
}

void framebuffer_size_callback(GLFWwindow* window, int width, int height) {
    SCR_WIDTH = width;
    SCR_HEIGHT = height;
    glViewport(0, 0, SCR_WIDTH, SCR_HEIGHT);
    m_renderer->updateProjection();
}