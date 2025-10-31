#!/usr/bin/env python3
"""
MLX Debug Build Verification Script

This script verifies that MLX was built with debug symbols
and provides information about profiling capabilities.
"""

import importlib.util
import subprocess
import sys


def check_mlx_installation():
    """Check if MLX is installed and importable."""
    try:
        import mlx.core as mx

        return True, mx.__file__
    except ImportError as e:
        return False, str(e)


def check_debug_symbols(lib_path):
    """Check if the MLX library has debug symbols."""
    try:
        result = subprocess.run(
            ["dwarfdump", "--lookup", "0x0", lib_path],
            capture_output=True,
            text=True,
            timeout=10,
        )
        return "debug_info" in result.stdout
    except (subprocess.TimeoutExpired, FileNotFoundError):
        # dwarfdump not available or failed
        return None


def check_profiling_tools():
    """Check which profiling tools are available."""
    tools = {}

    # Check py-spy
    try:
        result = subprocess.run(["py-spy", "--version"], capture_output=True, text=True)
        tools["py-spy"] = result.returncode == 0
    except FileNotFoundError:
        tools["py-spy"] = False

    # Check pyinstrument
    tools["pyinstrument"] = importlib.util.find_spec("pyinstrument") is not None

    # Check if we're on macOS (for Instruments)
    import platform

    tools["instruments"] = platform.system() == "Darwin"

    return tools


def main():
    print("🔍 MLX Debug Build Verification")
    print("===============================")

    # Check MLX installation
    mlx_installed, mlx_info = check_mlx_installation()
    if not mlx_installed:
        print(f"❌ MLX not installed: {mlx_info}")
        print("   Run: ./build_with_debug_symbols.sh")
        sys.exit(1)

    print(f"✅ MLX installed: {mlx_info}")

    # Check debug symbols
    has_debug = check_debug_symbols(mlx_info)
    if has_debug is True:
        print("✅ Debug symbols present")
    elif has_debug is False:
        print("❌ No debug symbols found")
        print("   Run: ./build_with_debug_symbols.sh")
    else:
        print("⚠️  Could not check debug symbols (dwarfdump not available)")

    # Test basic MLX functionality
    print("\n🧪 Testing MLX functionality...")
    try:
        import mlx.core as mx

        x = mx.array([1, 2, 3])
        y = mx.array([4, 5, 6])
        result = x + y
        print(f"✅ MLX test passed: {x} + {y} = {result}")
    except Exception as e:
        print(f"❌ MLX test failed: {e}")
        sys.exit(1)

    # Check profiling tools
    print("\n🛠️  Profiling Tools Status:")
    tools = check_profiling_tools()

    for tool, available in tools.items():
        status = "✅" if available else "❌"
        install_hint = ""
        if not available:
            if tool == "py-spy":
                install_hint = " (pip install py-spy)"
            elif tool == "pyinstrument":
                install_hint = " (pip install pyinstrument)"

        print(f"   {status} {tool}{install_hint}")

    # Provide next steps
    print("\n🎯 Next Steps:")
    if has_debug:
        print("   Your MLX is ready for profiling!")
        print("\n   Example profiling commands:")
        if tools.get("py-spy"):
            print("   • py-spy record -o profile.svg -- python your_app.py")
        if tools.get("pyinstrument"):
            print("   • pyinstrument your_app.py")
        if tools.get("instruments"):
            print("   • Open Instruments.app → Time Profiler")
    else:
        print("   Build MLX with debug symbols:")
        print("   • Run: ./build_with_debug_symbols.sh")

    print(f"\n📚 Documentation: docs/DEBUG_BUILD.md")


if __name__ == "__main__":
    main()
