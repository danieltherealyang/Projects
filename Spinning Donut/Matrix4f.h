#ifndef MATRIX4F_H
#define MATRIX4F_H

class Matrix4f {
    public:
        Matrix4f(float alpha, float beta, float gamma); //angle around x, y, and z axis rotations
        float get(int row, int col); //get matrix elements
        void setTranslate(float x, float y, float z); //one time translation
        void transform(float& x, float& y, float& z); //apply matrix transformation to coordinates
    private:
        float m_x = 0;
        float m_y = 0;
        float m_z = 0;
        float m_matrix[4][4];
};

#endif