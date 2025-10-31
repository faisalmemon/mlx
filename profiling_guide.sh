#!/bin/bash
# Profiling MLX applications without rebuilding the library

echo "🎯 MLX Profiling Setup"
echo "======================"

echo "1. Install profiling tools:"
echo "   brew install dtrace"  # System-level profiling
echo "   pip install py-spy"   # Python-specific profiling  
echo "   pip install pyinstrument"  # Python profiler

echo ""
echo "2. Profile your MLX application:"
echo "   # Time-based profiling"
echo "   py-spy top --pid \$(pgrep -f your_mlx_app.py)"
echo ""
echo "   # Record profiling session"
echo "   py-spy record -o profile.svg -- python your_mlx_app.py"
echo ""  
echo "   # Profile with pyinstrument"
echo "   pyinstrument your_mlx_app.py"

echo ""
echo "3. Use Instruments.app (macOS):"
echo "   - Open Instruments.app"
echo "   - Choose 'Time Profiler' template"
echo "   - Target your Python process"
echo "   - This will show MLX C++ function calls"

echo ""
echo "4. For GPU profiling:"
echo "   - Use Metal System Trace in Instruments"
echo "   - Profile Metal performance counters"
echo "   - MLX Metal kernels will show up"

echo ""
echo "✅ This approach works with any MLX installation!"
echo "🔍 You'll see MLX function names even without debug symbols"