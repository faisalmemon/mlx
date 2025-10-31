# MLX Development Makefile
# 
# Common development tasks for the MLX project

.PHONY: help build debug-build test clean install-dev profile-build

help: ## Show this help message
	@echo "MLX Development Commands:"
	@echo "========================"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build MLX (standard release build)
	pip install -e .

debug-build: ## Build MLX with debug symbols for profiling
	./build_with_debug_symbols.sh

profile-build: debug-build ## Alias for debug-build

install-dev: ## Install development dependencies
	pip install pytest py-spy pyinstrument cmake nanobind

test: ## Run tests
	python -m pytest tests/ -v

clean: ## Clean build artifacts
	rm -rf build python/build python/mlx.egg-info *.egg-info
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete

profile-example: debug-build ## Build with debug symbols and run a simple profile example
	@echo "Running example profiling session..."
	py-spy record -o mlx_profile.svg -d 5 -- python -c "\
import mlx.core as mx; \
import time; \
print('Running MLX operations for profiling...'); \
for i in range(10000): \
    x = mx.array([1.0, 2.0, 3.0]) * 2.0; \
    y = mx.sum(x); \
print('Done! Profile saved to mlx_profile.svg')"
	@echo "Open mlx_profile.svg to view the profile"

check-debug-symbols: ## Check if current MLX installation has debug symbols
	@python -c "\
import mlx.core as mx; \
lib_path = mx.__file__; \
print(f'MLX library: {lib_path}'); \
import subprocess; \
result = subprocess.run(['dwarfdump', '--lookup', '0x0', lib_path], capture_output=True, text=True); \
if 'debug_info' in result.stdout: \
    print('✅ Debug symbols present'); \
else: \
    print('❌ No debug symbols found'); \
    print('   Run: make debug-build');"