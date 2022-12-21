#include <iostream>
#include <chrono>
#include <ctime>
#include <thread>
#include "global.h"
#include "Shape.h"
#include "Renderer.h"
#include <string>
#include <ncurses.h>

using namespace std;

int main() {
    initscr();
    chrono::nanoseconds ns_per_frame(1000000000/FPS);
    Renderer renderer;
    Shape torus(&renderer);
    
    while (true) {
        chrono::time_point<chrono::system_clock> t_p = chrono::system_clock::now() + chrono::nanoseconds(ns_per_frame);

        renderer.render();
        torus.increment();

        this_thread::sleep_until(t_p);
    }
    endwin();
}