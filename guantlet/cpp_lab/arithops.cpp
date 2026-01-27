#include <iostream>

int main() {
    int students = 20;

    // Increment/decrement operators
    students++;
    students--;

    // Combined ops
    students += 1;
    students -= 2;
    students *= 2;
    students /= 2;

    // Modulo
    int num = 21;
    int remainder = num % 2;

    std::cout << remainder;

    return 0;
}