#include "gl.h"
#include "renderer.h"
#include <iostream>

Renderer::Renderer() {
    window = new Window(this);
    window->init();
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
    }

    shader = new Shader("resources/shaders/vertex.vs", "resources/shaders/fragment.fs");

    assets = new Assets();

    assets->loadCube();

    camera = new Camera(glm::vec3(0.0f, 0.0f, 5.0f), glm::vec3(0.0f, 0.0f, -1.0f));

    model = glm::mat4(1.0f);
    model = glm::rotate(model, glm::radians(-55.0f), glm::vec3(1.0f, 0.0f, 0.0f));
    view = camera->getView();
    projection = camera->getProjection();

    glEnable(GL_DEPTH_TEST);
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
}

void Renderer::start() {
    window->loop();
}

void Renderer::updateProjection() {
    projection = camera->getProjection();
}

void Renderer::update() {

}

void Renderer::render() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    view = camera->getView();

    GLint modelLocation = glGetUniformLocation(shader->getProgram(), "model");
    glUniformMatrix4fv(modelLocation, 1, GL_FALSE, glm::value_ptr(model));
    GLint viewLocation = glGetUniformLocation(shader->getProgram(), "view");
    glUniformMatrix4fv(viewLocation, 1, GL_FALSE, glm::value_ptr(view));
    GLint projLocation = glGetUniformLocation(shader->getProgram(), "projection");
    glUniformMatrix4fv(projLocation, 1, GL_FALSE, glm::value_ptr(projection));

    shader->useProgram();

    assets->draw();
}