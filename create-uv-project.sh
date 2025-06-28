#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

PROJECT="$1"

echo "Step 1/6: Creating project directory [$PROJECT]"
mkdir "$PROJECT" && cd "$PROJECT"

echo "Step 2/6: Installing uv (fast Python package manager)"
curl -Ls https://astral.sh/uv/install.sh | sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

echo "Step 3/6: Generating pyproject.toml with dependencies"
cat > pyproject.toml <<EOF
[project]
name = "$PROJECT"
version = "0.1.0"
requires-python = ">=3.8"
dependencies = []
EOF

echo "Step 4/6: Creating and activating virtual environment"
uv venv
. .venv/bin/activate

echo "Step 5/6: Installing dependencies via uv sync"
uv sync

echo "Step 6/6: Configuring VSCode and generating test script"
mkdir -p .vscode
cat > .vscode/settings.json <<EOF
{"python.defaultInterpreterPath": ".venv/bin/python"}
EOF

cat > test.py <<EOF
print("✅ Success.")
EOF

echo "✅ All steps completed. Opening project in VSCode..."
code .
