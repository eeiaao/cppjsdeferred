cmake_minimum_required(VERSION 3.5)

set(CMAKE_AUTOMOC ON)

find_package(Qt5 REQUIRED COMPONENTS Core Qml)

add_library(${PROJECT_NAME}
    promisefactory.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt5::Core
    Qt5::Qml
)
