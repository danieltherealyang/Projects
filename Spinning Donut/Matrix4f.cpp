#include "Matrix4f.h"
#include <cmath>

Matrix4f::Matrix4f(float alpha, float beta, float gamma) {
    m_matrix[0][0] = cos(beta)*cos(gamma); 
    m_matrix[0][1] = sin(alpha)*sin(beta)*cos(gamma) - cos(alpha)*sin(gamma);
    m_matrix[0][2] = cos(alpha)*sin(beta)*cos(gamma) + sin(alpha)*sin(gamma);
    m_matrix[0][3] = 0;
    m_matrix[1][0] = cos(beta)*sin(gamma);
    m_matrix[1][1] = sin(alpha)*sin(beta)*sin(gamma) + cos(alpha)*cos(gamma);
    m_matrix[1][2] = cos(alpha)*sin(beta)*sin(gamma) - sin(alpha)*cos(gamma);
    m_matrix[1][3] = 0;
    m_matrix[2][0] = -sin(beta);
    m_matrix[2][1] = sin(alpha)*cos(beta);
    m_matrix[2][2] = cos(alpha)*cos(beta);
    m_matrix[2][3] = 0;
    m_matrix[3][0] = 0;
    m_matrix[3][1] = 0;
    m_matrix[3][2] = 0;
    m_matrix[3][3] = 1;
}

float Matrix4f::get(int row, int col) {
    return m_matrix[row - 1][col - 1];
}

void Matrix4f::setTranslate(float x, float y, float z) {
    m_x = x;
    m_y = y;
    m_z = z;
}

void Matrix4f::transform(float& x, float& y, float& z) {
    x -= m_x; y -= m_y; z -= m_z;
    x = x*m_matrix[0][0] + y*m_matrix[0][1] + z*m_matrix[0][2] + m_x;
    y = x*m_matrix[1][0] + y*m_matrix[1][1] + z*m_matrix[1][2] + m_y;
    z = x*m_matrix[2][0] + y*m_matrix[2][1] + z*m_matrix[2][2] + m_z;
}