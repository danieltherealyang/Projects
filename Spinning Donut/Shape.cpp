#include "Shape.h"
#include "global.h"
#include <cmath>
#include <iostream>

#define PI 3.14159265
using namespace std;

Shape::Shape(Renderer* renderer) : m_renderer(renderer) {
    float theta = 0;
    while (theta < 2*PI) {
        float phi = 0;
        vector<Point> ring;
        while (phi < 2*PI) {
            Point p;
            p.x = (2+sin(phi))*cos(theta) + X_TRANS;
            p.y = (2+sin(phi))*sin(theta) + Y_TRANS;
            p.z = cos(phi) + Z_TRANS;
            p.n_x = (2+sin(phi))*cos(theta)*sin(phi) + p.x;
            p.n_y = (2+sin(phi))*sin(theta)*sin(phi) + p.y;
            p.n_z = (2+sin(phi))*cos(phi) + p.z;
            ring.push_back(p);
            m_renderer->mapPoint(p.x, p.y, p.z, getBrightness(p));
            phi += PHI_INC;
        }
        m_points.push_back(ring);
        theta += THETA_INC;
    }
}

void Shape::increment() {
    m_alpha += ALPHA; m_beta += BETA; m_gamma += GAMMA;
    if (m_alpha > 2*PI)
        m_alpha -= 2*PI;
    if (m_beta > 2*PI)
        m_beta -= 2*PI;
    if (m_gamma > 2*PI)
        m_gamma -= 2*PI;
    Matrix4f matrix(m_alpha, m_beta, m_gamma);
    matrix.setTranslate(X_TRANS, Y_TRANS, Z_TRANS);
        
    vector<vector<Point>>::iterator it;
    for (it = m_points.begin(); it != m_points.end(); it++) {
        vector<Point>::iterator pt;
        for (pt = it->begin(); pt != it->end(); pt++) {
            Point temp = *pt;
            matrix.transform(temp.x, temp.y, temp.z);
            matrix.transform(temp.n_x, temp.n_y, temp.n_z);
            m_renderer->mapPoint(temp.x, temp.y, temp.z, getBrightness(temp));
        }
    }
}

float Shape::getBrightness(Point p) {
    return p.n_z - p.z;
}