#include "camera.h"

Camera::Camera(glm::vec3 position, glm::vec3 front) {
    m_pos = position;
    m_front = glm::normalize(front);
    m_up = glm::vec3(0.0f, 1.0f, 0.0f);
    m_proj = glm::perspective(glm::radians(45.0f),  (float) SCR_WIDTH/SCR_HEIGHT, 0.1f, 100.0f);
    pitch = yaw = glm::degrees(acos(m_front.x));
}

glm::mat4 Camera::getView() {
    return glm::lookAt(m_pos, m_pos + m_front, m_up);
}

glm::mat4 Camera::getProjection() {
    return glm::perspective(glm::radians(45.0f), (float) SCR_WIDTH/SCR_HEIGHT, 0.1f, 100.0f);
}

void Camera::incPitch(float offset) {
    pitch += offset;
    if (pitch > 89.0f)
        pitch = 89.0f;
    if (pitch < -89.0f)
        pitch = -89.0f;
}

void Camera::incYaw(float offset) {
    yaw += offset;
    if (yaw > 360.0f)
        yaw -= 360.0f;
    if (yaw < -360.0f)
        yaw += 360.0f;
}

void Camera::updateDirection() {
    glm::vec3 direction;
    direction.x = cos(glm::radians(pitch)) * cos(glm::radians(yaw));
    direction.y = sin(glm::radians(pitch));
    direction.z = cos(glm::radians(pitch)) * sin(glm::radians(yaw));
    m_front = glm::normalize(direction);
}

void Camera::move(float speed, char direction) {
    switch (direction) {
        case 'F':
            m_pos += speed * m_front;
            break;
        case 'B':
            m_pos -= speed * m_front;
            break;
        case 'R':
            m_pos += speed * glm::normalize(glm::cross(m_front, m_up));
            break;
        case 'L':
            m_pos -= speed * glm::normalize(glm::cross(m_front, m_up));
            break;
        case 'U':
            m_pos += speed * m_up;
            break;
        case 'D':
            m_pos -= speed * m_up;
            break;
    } 
}