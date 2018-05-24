
int foo() {
    int* array = new int[100];
    delete [] array;
    return array[10]; // BOOM
}

int main(int, char**) {
    return foo();
}
