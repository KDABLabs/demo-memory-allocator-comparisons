/*
  SPDX-FileCopyrightText: 2025 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  SPDX-License-Identifier: MIT
*/

#include <iostream>
#include <string>

// extern otherwise compile might optimize out double deletes
extern void my_free_ptr(const char *ptr);
extern void my_free_ptr(int *value);
extern char *my_allocate_ptr(size_t size);
extern void my_no_op(void *);

void double_free()
{
    std::cout << "double_free\n";
    auto ptr = my_allocate_ptr(10000);
    my_free_ptr(ptr);
    my_free_ptr(ptr);
}

void use_after_free()
{
    std::cout << "use_after_free\n";
    auto ptr = my_allocate_ptr(50);
    my_free_ptr(ptr);
    ptr[0] = 42;
    ptr[50] = 42;
    my_no_op(ptr);
}

void free_invalid_ptr()
{
    int value = 0;
    std::cout << "free_invalid_ptr\n";
    my_free_ptr(&value);
}

#define HAS_ARG(arg) args_contains(argc, argv, arg)

bool args_contains(int argc, char **argv, std::string_view arg)
{
    for (int i = 1; i < argc; ++i) {
        if (argv[i] == arg) {
            return true;
        }
    }
    return false;
}

void print_usage()
{
    std::cout << "Usage:" << std::endl;
    std::cout << "  -d    double free" << std::endl;
    std::cout << "  -i    invalid free" << std::endl;
    std::cout << "  -u    use after free" << std::endl;
    std::cout << "  -l    leak memory" << std::endl;
}

void leak_memory()
{
    std::ignore = my_allocate_ptr(1024 * 1024);
}

int main(int argc, char **argv)
{
    std::cout << "LD_PRELOAD: " << (getenv("LD_PRELOAD") ? getenv("LD_PRELOAD") : "(not set)") << std::endl;

    if (HAS_ARG("-d")) {
        double_free();
    } else if (HAS_ARG("-u")) {
        use_after_free();
    } else if (HAS_ARG("-i")) {
        free_invalid_ptr();
    } else if (HAS_ARG("-l")) {
        leak_memory();
    } else {
        print_usage();
        return 1;
    }

    return 0;
}
