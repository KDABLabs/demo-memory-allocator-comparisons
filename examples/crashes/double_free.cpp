#include <iostream>

// extern otherwise compile might optimize out double deletes
extern void my_free_ptr(const char *ptr);

void double_free_crash()
{
    auto ptr = new char[10000];
    my_free_ptr(ptr);
    my_free_ptr(ptr);
}


int main(int argc, char **argv)
{
    std::cout << "LD_PRELOAD: " << (getenv("LD_PRELOAD") ? getenv("LD_PRELOAD") : "(not set)") << std::endl;

    double_free_crash();
    std::cout << "did not crash!\n";

    return 0;
}
