#ifndef CAMERA_H
#define CAMERA_H

#include "gl.h"
#include "headers/glm/glm.hpp"
#include "headers/glm/gtc/matrix_transform.hpp"
#include "headers/glm/gtc/type_ptr.hpp"

class Camera {
    private:
        glm::vec3 m_pos;
        glm::vec3 m_front;
        glm::vec3 m_up;
        glm::mat4 m_proj;
        float pitch;
        float yaw;
    public:
        Camera(glm::vec3 position, glm::vec3 front);
        glm::mat4 getView();
        glm::mat4 getProjection();
        void incPitch(float offset);
        void incYaw(float offset);
        void updateDirection();
        void move(float speed, char direction);
};

#endif