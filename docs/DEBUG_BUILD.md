# Building MLX with Debug Symbols

This guide explains how to build MLX with debug symbols for profiling and debugging purposes.

## Quick Start

```bash
./build_with_debug_symbols.sh
```

## Manual Command

If you prefer to run the command directly:

```bash
CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_ARGS="-DPython_EXECUTABLE=$(which python)" pip install -e . --force-reinstall --no-cache-dir
```

## What This Does

- **CMAKE_BUILD_TYPE=RelWithDebInfo**: Builds with `-O2` optimization AND debug symbols (`-g`)
- **Python_EXECUTABLE**: Ensures CMake uses the same Python version as pip
- **--force-reinstall**: Rebuilds everything from scratch
- **--no-cache-dir**: Avoids cached build artifacts

## Why RelWithDebInfo?

| Build Type | Optimization | Debug Symbols | Use Case |
|------------|--------------|---------------|----------|
| Debug | None (`-O0`) | Yes (`-g`) | Development/debugging |
| Release | Full (`-O2`) | No | Production |
| **RelWithDebInfo** | **Full (`-O2`)** | **Yes (`-g`)** | **Profiling** |
| MinSizeRel | Size (`-Os`) | No | Embedded systems |

**RelWithDebInfo** is perfect for profiling because you get production-like performance with debug information.

## Profiling MLX Applications

Once built with debug symbols, you can profile MLX functions in your applications:

### 1. Using py-spy (Recommended)

```bash
# Install py-spy
pip install py-spy

# Profile a running Python process
py-spy top --pid $(pgrep -f your_mlx_app.py)

# Record a profiling session
py-spy record -o profile.svg -- python your_mlx_app.py

# View the generated profile
open profile.svg
```

### 2. Using pyinstrument

```bash
# Install pyinstrument
pip install pyinstrument

# Profile your application
pyinstrument your_mlx_app.py

# Or from within Python
python -c "
import pyinstrument
profiler = pyinstrument.Profiler()
profiler.start()

# Your MLX code here
import mlx.core as mx
x = mx.array([1, 2, 3])
# ... more MLX operations ...

profiler.stop()
print(profiler.output_text(unicode=True, color=True))
"
```

### 3. Using macOS Instruments

1. Open **Instruments.app**
2. Choose **Time Profiler** template
3. Target your Python process
4. MLX C++ functions will appear with names and line numbers

### 4. Using dtrace (Advanced)

```bash
# Trace MLX function calls
sudo dtrace -n 'pid$target:mlx*::entry { printf("%s\\n", probefunc); }' -p $(pgrep python)
```

## Troubleshooting

### Python Version Mismatch

If you see errors like:
```
error: can't copy 'core.cpython-312-darwin.so': doesn't exist
```

This means CMake found a different Python version. The fix:
```bash
CMAKE_ARGS="-DPython_EXECUTABLE=$(which python)" pip install -e .
```

### Build Failures

1. **Clean build artifacts**:
   ```bash
   rm -rf build python/build python/mlx.egg-info
   ```

2. **Check Python environment**:
   ```bash
   which python
   python --version
   ```

3. **Verify dependencies**:
   ```bash
   pip install cmake nanobind
   ```

### Missing Debug Symbols

Verify debug symbols are present:
```bash
# Find MLX library location
python -c "import mlx.core as mx; print(mx.__file__)"

# Check for debug symbols
dwarfdump --lookup 0x0 /path/to/mlx/core.so | head -10
```

You should see `.debug_info contents:` if symbols are present.

## Performance Impact

Building with debug symbols:
- ✅ **No runtime performance penalty** (still fully optimized)
- ✅ **Enables detailed profiling** with function names
- ❌ **Larger binary size** (~2-3x due to debug info)
- ❌ **Longer build time** (slightly)

## For Production

For production deployments, use the regular release build:
```bash
pip install mlx
```

The debug symbols are only needed during development and profiling phases.