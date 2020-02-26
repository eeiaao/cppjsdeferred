find_package(Qt5QuickTest REQUIRED)

include_directories(${jspromisefactory_SOURCE_DIR}/src)

set(CMAKE_AUTOMOC ON)

# no need to copy around qml test files for shadow builds - just set the respective define
add_definitions(-DQUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")

add_executable(Test main.cpp)

target_link_libraries(Test PRIVATE
    cppjsdeferred

    Qt5::QuickTest
)

