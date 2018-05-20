
cmake_minimum_required(VERSION 3.8.2)

project(google-sanitizer-test CXX)

# Organize targets into folders.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Extend a list of directories specifying a search path for CMake modules
# to be loaded by the the include() or find_package() commands.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

add_executable(${PROJECT_NAME}
    Main.cpp
    )

include(GoogleSanitizers)
