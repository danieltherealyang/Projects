#ifndef RENDERER_H
#define RENDERER_H

#include <unordered_map>
#include <vector>
#include <string>

class Renderer {
    public:
        Renderer();
        void render();
        void mapPoint(float x, float y, float z, float brightness);
    private:
        std::unordered_map<std::string, std::pair<float,float>> m_zBuffer;
        int m_resolution;
        int m_charsetSize = 12;
        char m_charset[12] = {'.',',','-','~',':',':','=','!','*','#','$','@'};
        float m_maxBrightness = 2.5f;
        float m_minBrightness = 0.0f;
        std::vector<std::vector<char>> m_frame;
};

#endif