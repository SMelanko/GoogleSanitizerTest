
int main(int, char**) {
    int* array = new int[100];
    delete [] array;
    return array[10]; // BOOM
}

