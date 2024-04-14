#include "bool8_t/bool8_t.hpp"

#include <iostream>

int main()
{
    std::cout << "Size of the bool8_t class : " << sizeof(bool8_t) << " byte\n";

    // create an default instance. All flags is false
    bool8_t bool8;

    // change the flags
    bool8.flag0 = true;
    bool8.flag3 = true;

    // print the all flags using overloaded operator []
    std::cout << "1 test.\n";
    for (int i = 0; i < bool8.flagCount(); ++i)
        std::cout << i << ") " << std::boolalpha << bool8[i] << '\n';

    // set value for the all flags
    bool8 = false;
    if (!bool8)
        std::cout << "2 test.\nAll flags of the bool8 is false\n";

    // inverse flags
    bool8.inverse();
    if (bool8)
        std::cout << "3 test.\nAll flags of the bool8 is true\n";

    // rewrite and print the all flags using overloaded operator []
    std::cout << "4 test.\n";
    for (int i = 0; i < bool8.flagCount(); ++i)
    {
        if (i % 2)
            bool8[i] = false;

        std::cout << i << ") " << std::boolalpha << bool8[i] << '\n';
    }
}
