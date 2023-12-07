cmake_minimum_required(VERSION 3.18)

project(python-nis)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

find_package(Python3 REQUIRED COMPONENTS Interpreter Development.Module)
find_package(nis REQUIRED)

Python3_add_library(nis src/nismodule.c)
target_link_libraries(nis PRIVATE Python3::Module)
target_link_libraries(nis PRIVATE nis::nis)

install(TARGETS nis DESTINATION "${Python3_SITEARCH}")

message("Python3_SITEARCH: ${Python3_SITEARCH}")
message("Python3_SITELIB: ${Python3_SITELIB}")
message("Python3_STDLIB: ${Python3_STDLIB}")
message("Python3_STDARCH: ${Python3_STDARCH}")
message("CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
