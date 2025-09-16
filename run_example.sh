#!/bin/bash

set -e

print_usage() {
    echo "Usage: $0 [--jemalloc|--glibc|--mimalloc] <executable> [-u|-i|-d|-l]"
    echo "Environment variables:"
    echo "  LAUNCHER=gdb"
    echo "  LAUNCHER=valgrind"
    exit 1
}


# Check if 2 or 3 arguments are provided
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Error: Expected 2 or 3 arguments"
    print_usage
fi

if [ "$1" != "--jemalloc" ] && [ "$1" != "--glibc" ]  && [ "$1" != "--mimalloc" ]; then
    echo "Error: First argument must be either --jemalloc, --mimalloc or --glibc"
    print_usage
fi

# Parse arguments
ALLOCATOR="$1"
EXECUTABLE_NAME="$2"

# Check if last argument is -u, -i, or -d
DEBUG_FLAG=""
if [[ $# -eq 3 && "$3" =~ ^-[uidl]$ ]]; then
    DEBUG_FLAG="$3"
fi

if [ ! -f "$EXECUTABLE_NAME" ]; then
    echo "Error: executable '$EXECUTABLE_NAME' does not exist"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$ALLOCATOR" = "--jemalloc" ]; then
    export LD_PRELOAD="$SCRIPT_DIR/3rdparty/jemalloc/lib/libjemalloc.so.2"
    export MALLOC_CONF=tcache:false,junk:true
    
    if [ "$DEBUG_FLAG" = "-l" ]; then
        export MALLOC_CONF="$MALLOC_CONF,prof:true,prof_leak:true,lg_prof_sample:0,prof_final:true"
        echo "After running, run for example ./3rdparty/jemalloc/bin/jeprof build-debug/bin/demo_crash <file>.heap"
    fi
    
elif [ "$ALLOCATOR" = "--mimalloc" ]; then
    export LD_PRELOAD="$SCRIPT_DIR/3rdparty/mimalloc/libmimalloc-debug.so.2.2"
    export MIMALLOC_SHOW_ERRORS=1
    # export MIMALLOC_VERBOSE=1
    # export MIMALLOC_SHOW_STATS=1
    # export MIMALLOC_GUARDED_PRECISE=1
    export MIMALLOC_GUARDED_SAMPLE_RATE=1
fi

# Build the command
CMD="${LAUNCHER:+$LAUNCHER }${EXECUTABLE_NAME}"
if [ -n "$DEBUG_FLAG" ]; then
    CMD="$CMD $DEBUG_FLAG"
else
    print_usage
fi

# Execute the command
eval "$CMD"
