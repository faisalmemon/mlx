#!/bin/bash
# Build MLX with debug symbols for profiling

# Set environment
export CMAKE_BUILD_TYPE=RelWithDebInfo
export CMAKE_BUILD_PARALLEL_LEVEL=8

echo "🔧 Building MLX with RelWithDebInfo for profiling..."

# Clean any existing build artifacts
rm -rf build python/build

# Create a clean virtual environment
python -m venv mlx_debug_env
source mlx_debug_env/bin/activate

# Upgrade pip and install dependencies
pip install --upgrade pip setuptools wheel
pip install nanobind cmake

# Override the setup.py build type by modifying CMAKE_ARGS
export CMAKE_ARGS="-DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_CXX_FLAGS=-g -DCMAKE_C_FLAGS=-g"

# Build and install
pip install -e . --verbose

echo "✅ MLX built with debug symbols!"
echo "🎯 You can now profile MLX functions in your consuming applications"