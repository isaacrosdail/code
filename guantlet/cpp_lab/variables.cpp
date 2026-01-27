#include <iostream>

int main() {

    // int
    int x; // declaration
    x = 5; // assignment
    int y = 6;
    int age = 21;
    std::cout << x << std::endl;
    std::cout << y << std::endl;

    // double (number including decimal)
    double price = 10.99;
    double gpa = 2.5;
    double temperature = 25.1;

    // single character
    char grade = 'A';
    char initial = 'B';
    char currency = '$';

    // booleans
    bool isSexy = false;
    bool isDumb = true;

    // string (objs that represent a sequence of text)
    std::string name = "Steve";
    std::string day = "Friday";
    std::string food = "pizza";
    std::string address = "123 Fake St.";

    // std::cout << "Hello" << name << "\n";
    // std::cout << "You are " << age << " years old\n";

    // CONST: Makes a variable read-only, telling the compiler to prevent anything from modifying it
    const double PI = 3.14159; // compiler will flip a tit if we try to re-assign this
    const int LIGHT_SPEED = 299792458;
    double radius = 10;
    double circumference = 2 * PI * radius;

    std::cout << "Circumference is: " << circumference << " cm\n";

    return 0;
}