cmake_minimum_required(VERSION 3.18)

project(python-nis
        VERSION 0.0.1
        LANGUAGES C)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

find_package(Python3 REQUIRED COMPONENTS Interpreter Development.Module)
find_package(nis REQUIRED)

Python3_add_library(nis src/nismodule.c)
target_link_libraries(nis PRIVATE Python3::Module)
target_link_libraries(nis PRIVATE nis::nis)

install(TARGETS nis DESTINATION "${Python3_SITEARCH}")
