#include <iostream>

// cout << (insertion operator)
// cin >>  (extraction operator)

int main() {
    std::string name;
    int age;

    std::cout << "What's your name? ";
    // std::cin >> name; Note: if here, we have a space in our name, input would just end early once we hit enter here
    // The >> std::ws part eliminates any newline characters or any whitespaces before any user input
    std::getline(std::cin >> std::ws, name); // This way, we could enter a name like "Steve Smith" and user input would proceed as normal still

    std::cout << "What's your age? ";
    std::cin >> age;

    std::cout << "Hello " << name << "\n";
    std::cout << "You are " << age << " years old";

    return 0;
}