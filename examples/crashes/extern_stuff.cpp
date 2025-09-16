#include <cstddef>
#include <cstdlib>
#include <cstring>

void my_free_ptr(const char *ptr)
{
    delete[] ptr;
}

void my_free_ptr(int *value)
{
    delete[] value;
}

char *my_allocate_ptr(size_t size)
{
    auto ptr = new char[size];
    memset(ptr, 42, size);
    return ptr;
}

void my_no_op(void *)
{
}
