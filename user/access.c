#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    volatile int *addr = (int *) 0;
    *addr = 10;
    printf("Uncrashed\n");
}
