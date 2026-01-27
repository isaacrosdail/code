#include <iostream>
#include <vector>

// Suppose we wanna give this very long data type an alias:
// std::vector<std::pair<std::string, int>>

// // To spare our sanity, we can give an alias like:
// typedef std::vector<std::pair<std::string, int>> pairlist_t;
// // NOTE: A common convention when using the typedef keyword is having the
// // new identifier end with '_t' for type

// int main() {

//     // Declare a variable of this data type:
//     // std::vector<std::pair<std::string, int>> pairlist;
//     // Now, instead of having to use the original datatype, we can use the new identifier:
//     pairlist_t pairlist;

//     return 0;
// }


// typedef std::string str_t;
// typedef int number_t;

// int main() {
//     str_t firstName = "Steve";
//     number_t age = 21;

//     std::cout << firstName << "\n";
//     std::cout << age << "\n";
//     return 0;
// }

// HOWEVER, typedef has largely been replaced with the 'using' keyword, since it works better with templates
using str_t = std::string; // using <alias> = <original_name>;
using number_t = int;