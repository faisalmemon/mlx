#!/bin/bash
# MLX Debug Build Script
# 
# This script builds and installs MLX with RelWithDebInfo configuration,
# which provides optimized performance with debug symbols for profiling.
#
# Usage: ./build_with_debug_symbols.sh
#
# What this does:
# - Builds MLX with -O2 optimization + debug symbols (-g)
# - Fixes Python version mismatches during build
# - Enables profiling of MLX functions in consuming applications

set -e  # Exit on any error

echo "🔧 Building MLX with Debug Symbols for Profiling"
echo "==============================================="

# Check if we're in the right directory
if [[ ! -f "setup.py" || ! -f "CMakeLists.txt" ]]; then
    echo "❌ Error: This script must be run from the MLX repository root"
    echo "   (directory containing setup.py and CMakeLists.txt)"
    exit 1
fi

# Show current Python version
echo "🐍 Python version: $(python --version)"
echo "📍 Python location: $(which python)"

# Clean any previous build artifacts
echo "🧹 Cleaning previous build artifacts..."
rm -rf build python/build python/mlx.egg-info *.egg-info

# The key command that builds MLX with debug symbols
echo "🔨 Building MLX with RelWithDebInfo..."
echo "   - CMAKE_BUILD_TYPE=RelWithDebInfo (optimized + debug symbols)"
echo "   - Forcing Python executable consistency"
echo ""

CMAKE_BUILD_TYPE=RelWithDebInfo \
CMAKE_ARGS="-DPython_EXECUTABLE=$(which python)" \
pip install -e . --force-reinstall --no-cache-dir

echo ""
echo "✅ MLX built successfully with debug symbols!"

# Verify the installation
echo "🧪 Testing MLX installation..."
python -c "
import mlx.core as mx
x = mx.array([1, 2, 3])
y = mx.array([4, 5, 6])
result = x + y
print(f'✅ MLX test successful: {x} + {y} = {result}')
"

# Check for debug symbols
echo "🔍 Verifying debug symbols..."
MLX_LIB=$(python -c "import mlx.core as mx; print(mx.__file__)")
echo "📍 MLX library location: $MLX_LIB"

if dwarfdump --lookup 0x0 "$MLX_LIB" 2>/dev/null | grep -q "debug_info"; then
    echo "✅ Debug symbols confirmed present"
else
    echo "⚠️  Warning: Debug symbols may not be present"
fi

echo ""
echo "🎯 MLX is now ready for profiling!"
echo ""
echo "📊 You can now profile MLX in your applications using:"
echo "   • Instruments.app (macOS)"
echo "   • py-spy: py-spy record -o profile.svg -- python your_app.py"
echo "   • pyinstrument: pyinstrument your_app.py"
echo "   • dtrace/lldb for advanced debugging"
echo ""
echo "💡 The debug symbols will show MLX function names and line numbers"
echo "   in profiler stack traces, making performance analysis much easier."