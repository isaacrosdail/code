// Templates are a way of letting you write generically-typed code that is then made specific at compile time

// They are used everywhere:
// std::vector<T>
// std::map<K,V>
// std::optional<T>
// std::unique_ptr<T>
// std::sort<T>
// std::function<T>
// all of <algorithm>
// ... Everything in the Standard Library is template-based.

// When to learn templates:
// When using STL containers, <algorithm>, auto, lambdas, ranges, smart pointers
// When writing reusable code
// When building high-perf libs
// When dealing with CUDA kernel templates

// Ex 1: Function template (generic function)
template <typename T> // T is our type parameter
T add(T a, T b) {
    return a + b;
}

// The compiler literally generates a separate function for each type you use
// This is called template instantiation
int main() {
    add(1, 2);      // insantiates add<int>
    add(1.5, 2.7);  // instaniates add<double>
}

// Ex 2: Class template (generic container)
// Same idea, you define structure once, compiler produces multiple type-specific versions
template <typename T>
class Box {
    public:
        T value;
};

Box<int>   bi; // Box<int>
Box<float> bf; // Box<float>

