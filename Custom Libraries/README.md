# Custom Libraries
## Description
This folder is where I keep custom libraries that I made. It will mainly have libraries for utility functions rather than libraries for a specific platform or technology. For example, matrix multiplication, integers with boundless size, linear algebra operations, etc.
## BigInteger
This class is contained in a single .cpp file (might change in the future). The BigInteger class was initially created to solve a Hackerrank challenge but I put it in here in case I need it in the future. \
\
The class works by creating doubly linked list where each value in the linked list is a digit in the integer. The class currently only supports positive integer operations. The multiplication operator might not be the most efficient since a BigInteger must be copied over at the end. Space complexity might not be the best either since I used the traditional multiplication algorithm where all values must be summed.
\
For better space complexity, the Trachtenberg method might be a better algorithm.
\
Operators for this class are very limited because it was created solely to solve large factorials. Other functions will be added later as I need them.
