
#include <stdio.h>

int main(int, char**) {
    int* a = new int[10];
    a[5] = 0;

    if (a[2]) {
        printf("xx\n");
    }

    return 0;
}

