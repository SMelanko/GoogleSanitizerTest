
#include <pthread.h>
#include <stdio.h>

int Global;

void* Thread1(void*) {
    Global++;
    return NULL;
}

void* Thread2(void*) {
    Global--;
    return NULL;
}

void foo() {
    pthread_t t[2];
    pthread_create(&t[0], NULL, Thread1, NULL);
    pthread_create(&t[1], NULL, Thread2, NULL);
    pthread_join(t[0], NULL);
    pthread_join(t[1], NULL);
}

int main(int, char**) {
    foo();

    return 0;
}

