#!/bin/bash
# Manual CMake build for maximum control over debug symbols

echo "🔧 Manual MLX Build with Debug Symbols"
echo "======================================"

# Clean build
rm -rf build
mkdir build && cd build

# Configure with debug symbols
cmake .. \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DMLX_BUILD_PYTHON_BINDINGS=ON \
  -DMLX_BUILD_TESTS=OFF \
  -DMLX_BUILD_EXAMPLES=OFF \
  -DCMAKE_CXX_FLAGS="-g -O2" \
  -DCMAKE_C_FLAGS="-g -O2"

# Build
make -j$(nproc)

echo ""
echo "✅ MLX built with debug symbols in build/"
echo "📍 Library: build/libmlx.dylib"
echo "🔍 Has debug symbols for profiling"

# Check if symbols are present
echo ""
echo "Debug symbol check:"
nm -D build/libmlx.dylib | head -10