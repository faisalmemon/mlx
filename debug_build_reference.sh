#!/bin/bash
# MLX Debug Build - Quick Reference
# 
# This file contains all the commands and scripts for building MLX with debug symbols.
# Copy and paste any command, or run the scripts directly.

echo "🎯 MLX Debug Build - Quick Reference"
echo "===================================="
echo ""

echo "📝 Available Scripts:"
echo "   ./build_with_debug_symbols.sh    - Main build script"
echo "   ./verify_debug_build.py          - Verify debug symbols are present"
echo "   make debug-build                 - Alternative build command"
echo "   make check-debug-symbols         - Quick verification"
echo ""

echo "⚡ One-Line Command:"
echo "CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_ARGS=\"-DPython_EXECUTABLE=\$(which python)\" pip install -e . --force-reinstall --no-cache-dir"
echo ""

echo "🧹 Clean Build (if needed):"
echo "rm -rf build python/build python/mlx.egg-info"
echo ""

echo "🔍 Verify Installation:"
echo "python -c \"import mlx.core as mx; print('MLX location:', mx.__file__)\""
echo "dwarfdump --lookup 0x0 \$(python -c \"import mlx.core as mx; print(mx.__file__)\") | head -5"
echo ""

echo "📊 Profiling Commands:"
echo "   # Install profiling tools"
echo "   pip install py-spy pyinstrument"
echo ""
echo "   # Profile with py-spy"
echo "   py-spy record -o profile.svg -- python your_app.py"
echo ""
echo "   # Profile with pyinstrument"
echo "   pyinstrument your_app.py"
echo ""

echo "📚 Documentation:"
echo "   README.md                        - Updated with debug build info"
echo "   docs/DEBUG_BUILD.md              - Comprehensive debug build guide"
echo ""

echo "🎮 Quick Test:"
echo "python -c \""
echo "import mlx.core as mx"
echo "import time"
echo "start = time.time()"
echo "for i in range(1000):"
echo "    x = mx.array([1, 2, 3]) + mx.array([4, 5, 6])"
echo "print(f'✅ MLX operations completed in {time.time() - start:.4f}s')"
echo "print('🎯 Ready for profiling!')"
echo "\""