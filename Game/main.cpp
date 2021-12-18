#include <iostream>
#include "window.h"
using namespace std;
int main() {
    Window window(640, 480, "window title", NULL, NULL);
    window.start();
}