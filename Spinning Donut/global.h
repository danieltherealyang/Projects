#ifndef GLOBAL_H
#define GLOBAL_H

const float ALPHA = 0.2; //x,y,z angle rotation increments
const float BETA = 0.1;
const float GAMMA = 0.0;
const float PHI_INC = 0.1; //torus parameterization increments
const float THETA_INC = 0.1;
const float X_TRANS = 0; //translation mapping
const float Y_TRANS = 2;
const float Z_TRANS = 5;
const float X_LEFT = -5; const float X_RIGHT = 5; //viewport x range
const float Y_BOTTOM = -5; const float Y_TOP = 5; //viewport y range
const int RESOLUTION = 8; //chars per unit, rounds down to nearest multiple of 10
const int FPS = 12;

#endif