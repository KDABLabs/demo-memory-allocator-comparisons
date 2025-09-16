cmake_minimum_required(VERSION 3.21)
project(allocator-comparisons)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include(ExternalProject)

ExternalProject_Add(
    jemalloc
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/jemalloc
    BINARY_DIR ${CMAKE_SOURCE_DIR}/3rdparty/jemalloc
    CONFIGURE_COMMAND ${CMAKE_SOURCE_DIR}/3rdparty/jemalloc/autogen.sh --enable-debug --prefix=${CMAKE_BINARY_DIR}/installed/
    BUILD_COMMAND make -j5
)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

ADD_SUBDIRECTORY(examples/crashes)
