/*
RENDERER CLASS DESCRIPTION;
This class intended to call and assemble all other components of the game.
It will update the game state and communicate between classes when necessary.
update() - update game state;
render() - display game state on screen properly;
*/

#ifndef RENDERER_H
#define RENDERER_H

#include "window.h"
#include "assets.h"
#include "shader.h"
#include "camera.h"

class Renderer {
    private:
        Window* window;
        Shader* shader;
        Assets* assets;
        glm::mat4 model;
        glm::mat4 view;
        glm::mat4 projection;
    public:
        Camera* camera;
        Renderer();
        void start();
        void updateProjection();
        void update();
        void render();
};

#endif