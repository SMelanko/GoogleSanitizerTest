
#include <stdio.h>

void foo() {
    int* a = new int[10];
    a[5] = 0;

    if (a[2]) {
        printf("xx\n");
    }
}

int main(int, char**) {
    foo();

    return 0;
}

