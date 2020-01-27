cmake_minimum_required(VERSION 3.5)

project(jspromisefactory LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_subdirectory(src)
add_subdirectory(tests)

enable_testing ()
add_test (NAME jspromisefactory_qml_integration_test COMMAND Test)
