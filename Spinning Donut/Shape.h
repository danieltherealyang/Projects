#ifndef SHAPE_H
#define SHAPE_H

#include "Matrix4f.h"
#include "Renderer.h"
#include <vector>

class Shape {
    public:
        Shape(Renderer* renderer);
        void increment();
    private:
        struct Point {
            float x; float y; float z;
            float n_x; float n_y; float n_z;
        };
        Renderer* m_renderer;
        float m_alpha = 0; float m_beta = 0; float m_gamma = 0;
        std::vector<std::vector<Point>> m_points;
        float getBrightness(Point p);
};

#endif