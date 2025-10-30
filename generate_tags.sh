#!/bin/bash
# Regenerate ctags for the MLX repository

echo "Generating ctags for MLX repository..."
/opt/homebrew/bin/ctags --options=.ctags.d/mlx.ctags .
echo "✅ Tags generated successfully! ($(wc -l < tags) entries)"
echo "📍 Tags file location: $(pwd)/tags"