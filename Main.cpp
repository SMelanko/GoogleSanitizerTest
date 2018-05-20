#include <stdlib.h>

int main(int, char* []) {
    char* x = (char*)malloc(10 * sizeof(char*));
    free(x);
    return x[5];
}
