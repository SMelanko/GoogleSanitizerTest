
cmake_minimum_required(VERSION 3.8.2)

project(google-sanitizer-test CXX)

# Extend a list of directories specifying a search path for CMake modules
# to be loaded by the the include() or find_package() commands.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(cotire)
include(CxxCompilerOptions)

if (ENABLE_ASAN)
    set(SRC src/AsanMain.cpp)
elseif (ENABLE_MSAN)
    set(SRC src/MsanMain.cpp)
elseif (ENABLE_TSAN)
    set(SRC src/TsanMain.cpp)
endif ()

add_executable(${PROJECT_NAME} ${SRC})

include(GoogleSanitizers)

