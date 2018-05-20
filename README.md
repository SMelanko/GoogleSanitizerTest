# GoogleSanitizerTest

[Source](https://github.com/google/sanitizers)

```
mkdir -p build && cd build

cmake .. -DCMAKE_BUILD_TYPE:STRING=Debug -DENABLE_ASAN=ON
cmake .. -DCMAKE_BUILD_TYPE:STRING=Debug -DENABLE_MSAN=ON
cmake .. -DCMAKE_BUILD_TYPE:STRING=Debug -DENABLE_TSAN=ON

cmake --build . --config Debug
```
