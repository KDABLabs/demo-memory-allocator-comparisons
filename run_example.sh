#!/bin/bash

set -e

# Check if 2 or 3 arguments are provided
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Error: Expected 2 or 3 arguments"
    echo "Usage: $0 [--jemalloc|--glibc] [--gdb] <executable>"
    exit 1
fi

if [ "$1" != "--jemalloc" ] && [ "$1" != "--glibc" ]; then
    echo "Error: First argument must be either --jemalloc or --glibc"
    echo "Usage: $0 [--jemalloc|--glibc] [--gdb] <executable>"
    exit 1
fi

EXECUTABLE_NAME="${@: -1}"

if [ ! -f "$EXECUTABLE_NAME" ]; then
    echo "Error: executable '$EXECUTABLE_NAME' does not exist"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$1" = "--jemalloc" ]; then
    export LD_PRELOAD="$SCRIPT_DIR/3rdparty/jemalloc/lib/libjemalloc.so.2"
    export MALLOC_CONF=tcache:false
fi

if [[ "$*" == *"--gdb"* ]]; then
    MAYBE_GDB="gdb --args"
else
    MAYBE_GDB=""
fi

# last argument is executable
${MAYBE_GDB} "${EXECUTABLE_NAME}"
