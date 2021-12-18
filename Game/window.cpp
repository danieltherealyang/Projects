#include <iostream>
#include "headers/glad.h"
#include "headers/glfw3.h"
#include "window.h"
#include "shapes.h"

using namespace std;

Window::Window(int width, int height, char* title, GLFWmonitor* monitor, GLFWwindow* share) {
    glfwInit();
    m_window = glfwCreateWindow(width, height, title, monitor, share);
    init();
}

Window::~Window() {
    terminate();
}

void Window::init() {
    auto key_callback = [](GLFWwindow* window, int key, int scancode, int action, int mods) {
        if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
            glfwSetWindowShouldClose(window, GLFW_TRUE);
    };

    glfwSetKeyCallback(m_window, key_callback);

    auto framebuffer_size_callback = [](GLFWwindow* window, int width, int height) {
        glViewport(0, 0, width, height);
    };
    
    glfwMakeContextCurrent(m_window);
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        cout << "Failed to initialize GLAD" << endl;
    }

    glfwSetFramebufferSizeCallback(m_window, framebuffer_size_callback);
}

void Window::terminate() {
    glfwDestroyWindow(m_window);
    glfwTerminate();
}

void Window::start() {
    createVertexObjects();
    compileShaders();
    while (!glfwWindowShouldClose(m_window)) {
        glClearColor(0.2f,0.3f,0.3f,1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        render();
        glfwSwapBuffers(m_window);
        glfwPollEvents();
    }
}

void Window::render() {
    loadCube(0.0f, 0.0f, 0.0f, 1.0f);
    loadCubeElements();

    //main loop
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    glUseProgram(m_shaderProgram);
    glBindVertexArray(m_vao);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, 0);
}

void Window::createVertexObjects() {
    glGenVertexArrays(1, &m_vao);
    glBindVertexArray(m_vao);

    GLuint vbo;
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);

    GLuint ebo;
    glGenBuffers(1, &ebo);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
}

void Window::compileShaders() {
    const char* vertexShaderSource = "#version 330 core\n"
    "layout (location = 0) in vec3 aPos;\n"
    "void main()\n"
    "{\n"
    "   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
    "}\0";
    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);

    const char* fragmentShaderSource = "#version 330 core\n"
    "out vec4 FragColor;\n"
    "void main()\n"
    "{\n"
    "   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
    "}\0";
    unsigned int fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragmentShader);
    int  success;
    char infoLog[512];
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if(!success)
    {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
    }

    m_shaderProgram;
    m_shaderProgram = glCreateProgram();
    glAttachShader(m_shaderProgram, vertexShader);
    glAttachShader(m_shaderProgram, fragmentShader);
    glLinkProgram(m_shaderProgram);
    glDeleteShader(vertexShader);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*) 0);
    glEnableVertexAttribArray(0);
}