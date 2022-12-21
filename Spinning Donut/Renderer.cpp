#include "Renderer.h"
#include "global.h"
#include <iostream>
#include <sstream>
#include <string>
#include <cmath>
#include <ncurses.h>

using namespace std;

Renderer::Renderer() {
    m_resolution = RESOLUTION;
}

void Renderer::render() {
    m_frame.clear();
    float increment = (m_maxBrightness - m_minBrightness)/m_charsetSize;
    int rowSize = (int) (m_resolution * (X_RIGHT - X_LEFT));
    for (float i = Y_TOP; i > Y_BOTTOM; i -= 1.0f/m_resolution) {
        vector<char> row(rowSize);
        for (int j = 0; j < rowSize; j++) {
            float x = X_LEFT + j*1.0f/m_resolution;
            float y = i;
            float x_key = round(x * m_resolution)/m_resolution;
            float y_key = round(y * m_resolution)/m_resolution;

            stringstream keyStream;
            keyStream << x_key << "," << y_key;

            string key = keyStream.str();

            if (m_zBuffer.find(key) == m_zBuffer.end()) {
                row[j] = ' ';
            } else {
                float brightness = m_zBuffer.at(key).second;
                int index = (brightness - m_minBrightness)/increment;
                if (index >= m_charsetSize)
                    index = m_charsetSize - 1;
                if (index < 0)
                    index = 0;
                row[j] = m_charset[index];
            }
        }
        m_frame.push_back(row);
    }
    string frame = "";
    for (int i = 0; i < m_frame.size(); i++) {
        for (int j = 0; j < rowSize; j++) {
            frame += m_frame[i][j];
        }
        frame += '\n';
    }
    clear();
    printw(frame.c_str());
    refresh();
    m_zBuffer.clear();
}

void Renderer::mapPoint(float x, float y, float z, float brightness) {
    if (z < 0 || brightness < 0)
        return;
    float x_key = round(x * m_resolution)/m_resolution;
    float y_key = round(y * m_resolution)/m_resolution;
    stringstream keyStream;
    keyStream << x_key << "," << y_key;
    
    string key = keyStream.str();

    if (m_zBuffer.find(key) == m_zBuffer.end() || m_zBuffer.at(key).first > z) {
        m_zBuffer[key] = pair<float,float>(z, brightness);
    }
}