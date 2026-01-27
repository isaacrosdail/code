#include <iostream>

// Overall casting preference hierarchy?
// dynamic_cast -> static_cast -> reinterpret_cast -> const_cast > C-style cast

// QUICK RUNDOWN GUIDE:
// static_cast<T>()      // Safe, compile-time conversions (use 95% of the time)
// dynamic_cast<T>()     // Runtime polymorphism checks (inheritance stuff, safe downcasting in class hierarchies)
// const_cast<T>()       // Remove const (rare, usually code smell)
// reinterpret_cast<T>() // Raw memory reinterpretation (dangerous, low-level)

int main() {
    // Implicit cast
    int x = 3.14; // Result: 3

    // Explicit cast (C-style)
    // Precede the value with the new data type
    double y = (int) 4.56; // Result: 4

    // Proper explicit cast:
    double f = 3.11;
    int z = static_cast<int>(f); // Compiler checks type rules, no hidden reinterpretation, narrowing shows warnings

    int correct = 8;
    int total = 10;
    // double score = correct/total * 100; // This would basically do: 8/10 = 0.8 --truncates--> 0% :(
    // so instead we cast total as a double:
    double score = correct/ static_cast<double>(total) * 100;
    // Why only cast total though? That's because when we do int / double, C++
    // says: "these types don't match. Promote the int to double temporarily, then do double/double -> double result"
    // So, casting BOTH correct and total is redundant due to type promotion in C++


    std::cout << score << "%";

    return 0;
}