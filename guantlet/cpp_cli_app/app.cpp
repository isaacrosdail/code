#include <iostream>


// To use strings in switch cases, we can map strings to enums and switch on the enum
enum class Command { Quit, Invalid };

Command parseCmd(const std::string& s) {
    if (s == "q") return Command::Quit;
    return Command::Invalid;
};

int main() {
    std::string input;

    std::cout << "Welcome! Please enter a command (or q to quit)\n";

    bool running = true;
    while(running) {
        std::cout << ">> ";
        std::getline(std::cin >> std::ws, input);

        switch(parseCmd(input)) {
            case Command::Quit:
                std::cout << "Quitting\n";
                running = false;
                break;
            default: std::cout << "Invalid command\n";
        }
    }

    return 0;
}