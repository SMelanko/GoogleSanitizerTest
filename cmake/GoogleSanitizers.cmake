
#
# Google Sanitizers (https://github.com/google/sanitizers)
# --------------------------------------------------------------------------------------------------
#
# Dynamic testing tools for C/C++:
# - AddressSanitizer (ASan) is a fast memory error detector. It finds use-after-free
#   and {heap,stack,global}-buffer overflow bugs in C/C++ programs.
# - MemorySanitizer (MSan) is a fast LLVM-based tool that detects the use of uninitialized memory.
# - ThreadSanitizer (TSan) is a fast data race detector for C/C++ programs.
# These tools are based on compiler instrumentation (LLVM and GCC), which makes them very fast,
# for example ASan incurs just 2x slowdown.
#
# GCC options - https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html
#

if (WIN32)
    message(WARNING "Please note, there is no Windows support for Google Sanitizers")
    return()
endif ()

if (ENABLE_ASAN)
    # Generates debug information to be used by GDB debugger, -g - default debug information.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
    # Sets the compiler's optimization level, -O1 - optimization for code size and execution time.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O1")
    # Specifies the gold linker, https://en.wikipedia.org/wiki/Gold_(linker).
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fuse-ld=gold")
    # Instructs the compiler to store the stack frame pointer in a register. If you specify
    # -fno-omit-frame-pointer, then any function which uses space on the stack creates
    # a frame record, and changes the frame pointer to point to it.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-omit-frame-pointer")
    # Enables AddressSanitizer, a fast memory error detector. Memory access instructions are
    # instrumented to detect out-of-bounds and use-after-free bugs.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=address")
    # Enables LeakSanitizer, a memory leak detector. This option only matters for linking
    # of executables and the executable is linked against a library that overrides malloc
    # and other allocator functions.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=leak")
endif ()

if (ENABLE_MSAN)
    # Specifies the gold linker, https://en.wikipedia.org/wiki/Gold_(linker).
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fuse-ld=gold")
    # Enables UndefinedBehaviorSanitizer, a fast undefined behavior detector. Various computations
    # are instrumented to detect undefined behavior at runtime.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=undefined")
endif ()

if (ENABLE_TSAN)
    # Specifies the gold linker, https://en.wikipedia.org/wiki/Gold_(linker).
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fuse-ld=gold")
    # Enables ThreadSanitizer, a fast data race detector. Memory access instructions are
    # instrumented to detect data race bugs.
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fsanitize=thread")
endif ()
