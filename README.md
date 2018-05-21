# GoogleSanitizerTest

[Source](https://github.com/google/sanitizers)

```
mkdir -p build && cd build

cmake .. -DCMAKE_BUILD_TYPE:STRING=Debug -DENABLE_ASAN=ON
cmake .. -DCMAKE_BUILD_TYPE:STRING=Debug -DENABLE_MSAN=ON
cmake .. -DCMAKE_BUILD_TYPE:STRING=Debug -DENABLE_TSAN=ON

cmake --build . --config Debug
```

# [AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer)

Use after free case

``` cpp
int main(int, char* []) {
    int* array = new int[100];
    delete [] array;

    return array[10]; // BOOM!
}
```

The result is

```
vmelanko@smela:~/proj/GoogleSanitizerTest/build$ ./google-sanitizer-test 
=================================================================
==30411==ERROR: AddressSanitizer: heap-use-after-free on address 0x614000000068 at pc 0x562bdc7f18ff bp 0x7fff9fa0c7c0 sp 0x7fff9fa0c7b0
READ of size 4 at 0x614000000068 thread T0
    #0 0x562bdc7f18fe in main /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:6
    #1 0x7f67e083b1c0 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x211c0)
    #2 0x562bdc7f17c9 in _start (/home/vmelanko/proj/GoogleSanitizerTest/build/google-sanitizer-test+0x7c9)

0x614000000068 is located 40 bytes inside of 400-byte region [0x614000000040,0x6140000001d0)
freed by thread T0 here:
    #0 0x7f67e0cdb490 in operator delete[](void*) (/usr/lib/x86_64-linux-gnu/libasan.so.4+0xe1490)
    #1 0x562bdc7f18cc in main /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:4
    #2 0x7f67e083b1c0 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x211c0)

previously allocated by thread T0 here:
    #0 0x7f67e0cda618 in operator new[](unsigned long) (/usr/lib/x86_64-linux-gnu/libasan.so.4+0xe0618)
    #1 0x562bdc7f18bc in main /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:3
    #2 0x7f67e083b1c0 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x211c0)

SUMMARY: AddressSanitizer: heap-use-after-free /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:6 in main
Shadow bytes around the buggy address:
  0x0c287fff7fb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7fc0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7fd0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7fe0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0x0c287fff7ff0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>0x0c287fff8000: fa fa fa fa fa fa fa fa fd fd fd fd fd[fd]fd fd
  0x0c287fff8010: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c287fff8020: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c287fff8030: fd fd fd fd fd fd fd fd fd fd fa fa fa fa fa fa
  0x0c287fff8040: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c287fff8050: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
==30411==ABORTING
```

# [MemorySanitizer](https://github.com/google/sanitizers/wiki/MemorySanitizer)

``` cpp
#include <stdio.h>

int main(int argc, char** argv) {
    int* a = new int[10];
    a[5] = 0;

    if (a[2]) {
        printf("xx\n");
    }

    return 0;
}
```

The result is

```
vmelanko@smela:~/proj/GoogleSanitizerTest/build$ ./google-sanitizer-test 
xx

=================================================================
==30675==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 40 byte(s) in 1 object(s) allocated from:
    #0 0x7f699405d618 in operator new[](unsigned long) (/usr/lib/x86_64-linux-gnu/libasan.so.4+0xe0618)
    #1 0x55cabb4d7c0c in main /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:5
    #2 0x7f6992e9d1c0 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x211c0)

SUMMARY: AddressSanitizer: 40 byte(s) leaked in 1 allocation(s).
```

# [ThreadSanitizer](https://github.com/google/sanitizers/wiki/ThreadSanitizerCppManual)

``` cpp
#include <pthread.h>
#include <stdio.h>

int Global;

void* Thread1(void* x) {
    Global++;
    return NULL;
}

void* Thread2(void* x) {
    Global--;
    return NULL;
}

int main() {
    pthread_t t[2];
    pthread_create(&t[0], NULL, Thread1, NULL);
    pthread_create(&t[1], NULL, Thread2, NULL);
    pthread_join(t[0], NULL);
    pthread_join(t[1], NULL);
}
```

The result is

```
vmelanko@smela:~/proj/GoogleSanitizerTest/build$ ./google-sanitizer-test 
==================
WARNING: ThreadSanitizer: data race (pid=30998)
  Read of size 4 at 0x56211526701c by thread T2:
    #0 Thread2(void*) /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:13 (google-sanitizer-test+0x000000000b62)
    #1 <null> <null> (libtsan.so.0+0x000000025aab)

  Previous write of size 4 at 0x56211526701c by thread T1:
    #0 Thread1(void*) /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:8 (google-sanitizer-test+0x000000000b23)
    #1 <null> <null> (libtsan.so.0+0x000000025aab)

  Location is global 'Global' of size 4 at 0x56211526701c (google-sanitizer-test+0x00000000301c)

  Thread T2 (tid=31001, running) created by main thread at:
    #0 pthread_create <null> (libtsan.so.0+0x0000000290c3)
    #1 main /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:20 (google-sanitizer-test+0x000000000bf3)

  Thread T1 (tid=31000, finished) created by main thread at:
    #0 pthread_create <null> (libtsan.so.0+0x0000000290c3)
    #1 main /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:19 (google-sanitizer-test+0x000000000bd2)

SUMMARY: ThreadSanitizer: data race /home/vmelanko/proj/GoogleSanitizerTest/Main.cpp:13 in Thread2(void*)
==================
ThreadSanitizer: reported 1 warnings

```

