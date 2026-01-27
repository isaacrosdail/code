#include <iostream>

// Namespace = provides solution for preventing name conflicts. Each entity needs a unique name. Namespaces allow for identically named entities as long as the namespaces are different.

// Creating a namespace:
namespace first {
    int x = 1;
}

namespace second {
    int x = 2;
}
int main() {
    int x = 0;
    // int x = 1; // cannot do :(

    std::cout << x; // Without specifying namespace, we of course default to the local namespace
    std::cout << first::x; // :: is the scope resolution operator
    std::cout << second::x;

    return 0;
}

// We can use 'using namespace __' to set the namespace so we don't need to prefix stuff like that:
/*
int main() {
    using namespace first;

    std::cout << x; // This would print 1

    return 0;
}

// We can do this, but this is bad - tons of potential naming conflicts.
int main() {
    using namespace std;
    string name = "Bro";
    cout << "Hello " << name;
    return 0;
}

// Instead, we can be much more specific. This is vastly preferred:
int main() {
    using std::cout;
    using std::string;

    string name = "bro";
    cout << "Hey " << name;
    return 0;
}

*/