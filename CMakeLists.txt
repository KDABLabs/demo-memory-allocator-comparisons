# SPDX-FileCopyrightText: 2025 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.21)
project(allocator-comparisons)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include(ExternalProject)

ExternalProject_Add(
    jemalloc
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/jemalloc
    BINARY_DIR ${CMAKE_SOURCE_DIR}/3rdparty/jemalloc
    CONFIGURE_COMMAND ${CMAKE_SOURCE_DIR}/3rdparty/jemalloc/autogen.sh --enable-prof --enable-fill --enable-debug --prefix=${CMAKE_BINARY_DIR}/installed/
    BUILD_COMMAND make -j5
)

ExternalProject_Add(
    mimalloc
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rdparty/mimalloc
    BINARY_DIR ${CMAKE_SOURCE_DIR}/3rdparty/mimalloc
    CONFIGURE_COMMAND cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug -DMI_GUARDED=ON -DMI_SECURE=ON -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}/installed
    BUILD_COMMAND ninja
    INSTALL_COMMAND ninja install
)


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

ADD_SUBDIRECTORY(examples/crashes)
