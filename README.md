# Introduction

Repo for easily comparing different C++ memory allocators.

# Build

```bash
git submodule update --init --recursive
cmake --preset=default
cmake --build build-debug
./run_example.sh --jemalloc ./build-debug/bin/crash_double_free
```
